#include "ass6_20CS10021_20CS30051_translator.h"

string inpFile, asmFile;
ActivationRecord *curAR;
ofstream asmOut;

map<int, string> retSizeRegMap = { {1, "al"}, {4, "eax"}, {8, "rax"} };
map<int, string> arg1SizeRegMap = { {1, "dil"}, {4, "edi"}, {8, "rdi"} };
map<int, string> arg2SizeRegMap = { {1, "sil"}, {4, "esi"}, {8, "rsi"} };
map<int, string> arg3SizeRegMap = { {1, "dl"}, {4, "edx"}, {8, "rdx"} };
map<int, string> arg4SizeRegMap = { {1, "cl"}, {4, "ecx"}, {8, "rcx"} };
map<int, map<int, string>> argNum2RegMap = { {1, arg1SizeRegMap}, {2, arg2SizeRegMap}, {3, arg3SizeRegMap}, {4, arg4SizeRegMap} };

string getReg(string paramName, int paramNum, int size) {
    string reg = argNum2RegMap[paramNum][size];
    return "%" + reg;
}

string getStackLoc(string paramName) {
    if(curAR->offset.count(paramName))
        return toString(curAR->offset[paramName]) + "(%rbp)";
    else return paramName;
}

void storeParam(string paramName, int paramNum) {
    Sym *sym = curTable->lookup(paramName);
    int size = sym->size;
    SymType::typeEnum type = sym->type->type;
    string movIns = "";
    if(type == SymType::Array) {
        movIns = "leaq";
        size = 8;
    } else if (size == 1) {
        movIns = "movb";
    } else if (size == 4) {
        movIns = "movl";
    } else if (size == 8) {
        movIns = "movq";
    }
    string reg = getReg(paramName, paramNum, size);
    asmOut << "\t" << setw(8) << movIns << getStackLoc(paramName) << ", " << reg << endl;
}

void loadParam(string paramName, int paramNum) {
    Sym *sym = curTable->lookup(paramName);
    int size = sym->size;
    SymType::typeEnum type = sym->type->type;
    string movIns = "";
    if(type == SymType::Array) {
        movIns = "movq";
        size = 8;
    } else if (size == 1) {
        movIns = "movb";
    } else if (size == 4) {
        movIns = "movl";
    } else if (size == 8) {
        movIns = "movq";
    }
    string reg = getReg(paramName, paramNum, size);
    asmOut << "\t" << setw(8) << movIns << reg << ", " << getStackLoc(paramName) << endl;
}

map<char, int> escCharAsciiVal = { 
    {'n', 10}, 
    {'t', 9},
    {'r', 13}, 
    {'b', 8}, 
    {'f', 12}, 
    {'v', 11}, 
    {'a', 7}, 
    {'0', 0}
};

int getAsciiValue(string charConst) {
    if(charConst.length() == 3) {
        return (int)charConst[1];
    }
    else {
        if(escCharAsciiVal.find(charConst[2]) != escCharAsciiVal.end()) {
            return escCharAsciiVal[charConst[2]];
        }
        else {
            return (int)charConst[2];
        }
    }
}

void translate() {
    asmOut.open(asmFile);

    asmOut << left;
    asmOut << "\t.file\t\"" + inpFile + "\"" << endl;

    asmOut << endl;
    asmOut << "#\t" << "Allocation of function variables and temporaries on the stack:\n" << endl;
    for(auto &sym : globalTable->syms) {
        if(sym.second.category == Sym::FUNCTION) {
            asmOut << "#\t" << sym.second.name << endl;
            for(auto &record: sym.second.nestedTable->activationRecord->offset) {
                asmOut << "#\t" << record.first << ": " << record.second << endl;
            }
        }
    }
    asmOut << endl;
    if(strLiterals.size() > 0) {
        asmOut << "\t.section\t.rodata" << endl;
        int i = 0;
        for(auto &stringLiteral : strLiterals) {
            asmOut << ".LC" << i++ << ":" << endl;
            asmOut << "\t.string\t" << stringLiteral << endl;
        }
    }
    for(auto &sym:globalTable->syms) {
        if(sym.second.initialValue.empty() && sym.second.category == Sym::GLOBAL) {
            asmOut << "\t.comm\t" << sym.first << "," << sym.second.size << "," << sym.second.size << endl;
        }
    }

    map<int, string> lblMap;
    int qNum = 1, lblNum = 0;
    for(auto &quad:qArray) {
        if(quad->op == "label") {
            lblMap[qNum] = ".LFB" + toString(lblNum);
        } else if(quad->op == "labelend") {
            lblMap[qNum] = ".LFE" + toString(lblNum);
            lblNum++;
        }
        qNum++;
    }
    for(auto &quad:qArray) {
        if(quad->op == "goto" or quad->op == "==" or quad->op == "!=" or quad->op == "<" or quad->op == ">" or quad->op == "<=" or quad->op == ">=") {
            int loc = stoi(quad->result);
            if(lblMap.find(loc) == lblMap.end()) {
                lblMap[loc] = ".L" + toString(lblNum);
                lblNum++;
            }
        }
    }

    bool inTextSpace = false;
    string globalStringTemp;
    int globalIntTemp, globalCharTemp;
    string funcEndLabel;
    stack<string> params;
    qNum = 1;
    for(auto &quad:qArray) {

        if(quad->op == "label") {
            if(!inTextSpace) {
                asmOut << "\t.text" << endl;
                inTextSpace = true;
            }
            curTable = globalTable->lookup(quad->result)->nestedTable;
            curAR = curTable->activationRecord;
            funcEndLabel = lblMap[qNum];
            funcEndLabel[3] = 'E';
            asmOut << "\t" << setw(8) << ".globl" << quad->result << endl;
            asmOut << "\t" << setw(8) << ".type" << quad->result << ", @function" << endl;
            asmOut << quad->result << ":" << endl;
            asmOut << lblMap[qNum] << ":" << endl;
            asmOut << "\t" << ".cfi_startproc" << endl;
            asmOut << "\t" << setw(8) << "pushq" << "%rbp" << endl;
            asmOut << "\t.cfi_def_cfa_offset 16" << endl;
            asmOut << "\t.cfi_offset 6, -16" << endl;
            asmOut << "\t" << setw(8) << "movq" << "%rsp, %rbp" << endl;
            asmOut << "\t.cfi_def_cfa_register 6" << endl;
            asmOut << "\t" << setw(8) << "subq" << "$" << -curAR->totOffset << ", %rsp" << endl;
            int paramNum = 1;
            for(auto param:curTable->parameters) {
                loadParam(param, paramNum);
                paramNum++;
            }
        } else if(quad->op == "labelend") {
            asmOut << lblMap[qNum] << ":" << endl;
            asmOut << "\t" << setw(8) << "movq" << "%rbp, %rsp" << endl;
            asmOut << "\t" << setw(8) << "popq" << "%rbp" << endl;
            asmOut << "\t" << ".cfi_def_cfa 7, 8" << endl;
            asmOut << "\t" << "ret" << endl;
            asmOut << "\t" << ".cfi_endproc" << endl;
            asmOut << "\t" << setw(8) << ".size" << quad->result << ", .-" << quad->result << endl;
            inTextSpace = false;
        } else {
            if(inTextSpace) {
                string op = quad->op;
                string result = quad->result;
                string arg1 = quad->arg1;
                string arg2 = quad->arg2;
                if(lblMap.count(qNum)) {
                    asmOut << lblMap[qNum] << ":" << endl;
                }
                if(op == "=") {
                    if(isdigit(arg1[0])) {
                        asmOut << "\t" << setw(8) << "movl" << "$" << arg1 << ", " << getStackLoc(result) << endl;
                    } else if(arg1[0] == '\''){
                        asmOut << "\t" << setw(8) << "movb" << "$" << getAsciiValue(arg1) << ", " << getStackLoc(result) << endl;
                    } else {
                        int sz = curTable->lookup(arg1)->size;
                        if(sz == 1) {
                            asmOut << "\t" << setw(8) << "movb" << getStackLoc(arg1) << ", %al" << endl;
                            asmOut << "\t" << setw(8) << "movb" << "%al, " << getStackLoc(result) << endl;
                        } else if(sz == 4) {
                            asmOut << "\t" << setw(8) << "movl" << getStackLoc(arg1) << ", %eax" << endl;
                            asmOut << "\t" << setw(8) << "movl" << "%eax, " << getStackLoc(result) << endl;
                        } else if(sz == 8) {
                            asmOut << "\t" << setw(8) << "movq" << getStackLoc(arg1) << ", %rax" << endl;
                            asmOut << "\t" << setw(8) << "movq" << "%rax, " << getStackLoc(result) << endl;
                        }
                    }
                } else if(op == "=str") {
                    asmOut << "\t" << setw(8) << "movq" << "$.LC" << arg1 << ", " << getStackLoc(result) << endl;
                } else if(op == "param") {
                    params.push(result);
                } else if(op == "call") {
                    int paramCount = stoi(arg2);
                    while (paramCount) {
                        storeParam(params.top(), paramCount);
                        params.pop();
                        paramCount--;
                    }
                    asmOut << "\t" << setw(8) << "call" << arg1 << endl;
                    int sz = curTable->lookup(result)->size;
                    if(sz == 1) {
                        asmOut << "\t" << setw(8) << "movb" << "%al, " << getStackLoc(result) << endl;
                    } else if(sz == 4) {
                        asmOut << "\t" << setw(8) << "movl" << "%eax, " << getStackLoc(result) << endl;
                    } else if(sz == 8) {
                        asmOut << "\t" << setw(8) << "movq" << "%rax, " << getStackLoc(result) << endl;
                    }
                } else if(op == "return") {
                    if(!result.empty()) {
                        int sz = curTable->lookup(result)->size;
                        if(sz == 1) {
                            asmOut << "\t" << setw(8) << "movb" << getStackLoc(result) << ", %al" << endl;
                        } else if(sz == 4) {
                            asmOut << "\t" << setw(8) << "movl" << getStackLoc(result) << ", %eax" << endl;
                        } else if(sz == 8) {
                            asmOut << "\t" << setw(8) << "movq" << getStackLoc(result) << ", %rax" << endl;
                        }
                    }
                    if(qArray[qNum]->op != "labelend")
                        asmOut << "\t" << setw(8) << "jmp" << funcEndLabel << endl;
                } else if(op == "goto") {
                    asmOut << "\t" << setw(8) << "jmp" << lblMap[stoi(result)] << endl;
                } else if(op == "==" or op == "!=" or op == "<" or op == "<=" or op == ">" or op == ">=") {
                    int sz = curTable->lookup(arg1)->size;
                    string movins, cmpins, movreg;
                    if(sz == 1) {
                        movins = "movb";
                        cmpins = "cmpb";
                        movreg = "%al";
                    } else if(sz == 4) {
                        movins = "movl";
                        cmpins = "cmpl";
                        movreg = "%eax";
                    } else if(sz == 8) {
                        movins = "movq";
                        cmpins = "cmpq";
                        movreg = "%rax";
                    }
                    asmOut << "\t" << setw(8) << movins << getStackLoc(arg2) << ", " << movreg << endl;
                    asmOut << "\t" << setw(8) << cmpins << movreg << ", " << getStackLoc(arg1) << endl;
                    if(op == "==") {
                        asmOut << "\t" << setw(8) << "je" << lblMap[stoi(result)] << endl;
                    } else if(op == "!=") {
                        asmOut << "\t" << setw(8) << "jne" << lblMap[stoi(result)] << endl;
                    } else if(op == "<") {
                        asmOut << "\t" << setw(8) << "jl" << lblMap[stoi(result)] << endl;
                    } else if(op == "<=") {
                        asmOut << "\t" << setw(8) << "jle" << lblMap[stoi(result)] << endl;
                    } else if(op == ">") {
                        asmOut << "\t" << setw(8) << "jg" << lblMap[stoi(result)] << endl;
                    } else if(op == ">=") {
                        asmOut << "\t" << setw(8) << "jge" << lblMap[stoi(result)] << endl;
                    }
                } else if(op == "+") {
                    if(result == arg1) {
                        asmOut << "\t" << setw(8) << "incl" << getStackLoc(arg1) << endl;
                    } else {
                        asmOut << "\t" << setw(8) << "movl" << getStackLoc(arg1) << ", " << "%eax" << endl;
                        asmOut << "\t" << setw(8) << "addl" << getStackLoc(arg2) << ", " << "%eax" << endl;
                        asmOut << "\t" << setw(8) << "movl" << "%eax" << ", " << getStackLoc(result) << endl;
                    }
                } else if(op == "-") {
                    if(result == arg1) {
                        asmOut << "\t" << setw(8) << "decl" << getStackLoc(arg1) << endl;
                    }
                    else {
                        asmOut << "\t" << setw(8) << "movl" << getStackLoc(arg1) << ", " << "%eax" << endl;
                        asmOut << "\t" << setw(8) << "subl" << getStackLoc(arg2) << ", " << "%eax" << endl;
                        asmOut << "\t" << setw(8) << "movl" << "%eax" << ", " << getStackLoc(result) << endl;
                    }
                } else if(op == "*") {
                    asmOut << "\t" << setw(8) << "movl" << getStackLoc(arg1) << ", " << "%eax" << endl;
                    if(isdigit(arg2[0])) {
                        asmOut << "\t" << setw(8) << "imull" << "$" + getStackLoc(arg2) << ", " << "%eax" << endl;
                    } else { 
                        asmOut << "\t" << setw(8) << "imull" << getStackLoc(arg2) << ", " << "%eax" << endl;
                    }
                    asmOut << "\t" << setw(8) << "movl" << "%eax" << ", " << getStackLoc(result) << endl;
                } else if(op == "/") {
                    asmOut << "\t" << setw(8) << "movl" << getStackLoc(arg1) << ", " << "%eax" << endl;
                    asmOut << "\t" << setw(8) << "cdq" << endl;
                    asmOut << "\t" << setw(8) << "idivl" << getStackLoc(arg2) << endl;
                    asmOut << "\t" << setw(8) << "movl" << "%eax" << ", " << getStackLoc(result) << endl;
                } else if(op == "%") {
                    asmOut << "\t" << setw(8) << "movl" << getStackLoc(arg1) << ", " << "%eax" << endl;
                    asmOut << "\t" << setw(8) << "cdq" << endl;
                    asmOut << "\t" << setw(8) << "idivl" << getStackLoc(arg2) << endl;
                    asmOut << "\t" << setw(8) << "movl" << "%edx" << ", " << getStackLoc(result) << endl;
                } else if(op == "=[]") {
                    Sym *sym = curTable->lookup(arg1);
                    if(sym->category == Sym::PARAMETER) {
                        asmOut << "\t" << setw(8) << "movl" << getStackLoc(arg2) << ", " << "%eax" << endl;
                        asmOut << "\t" << setw(8) << "cltq" << endl;
                        asmOut << "\t" << setw(8) << "addq" << getStackLoc(arg1) << ", " << "%rax" << endl;
                        asmOut << "\t" << setw(8) << "movl" << "(%rax)" << ", " << "%eax" << endl;
                        asmOut << "\t" << setw(8) << "movl" << "%eax" << ", " << getStackLoc(result) << endl;
                    } else {
                        asmOut << "\t" << setw(8) << "movl" << getStackLoc(arg2) << ", " << "%eax" << endl;
                        asmOut << "\t" << setw(8) << "cltq" << endl;
                        asmOut << "\t" << setw(8) << "movl" << curAR->offset[arg1] << "(%rbp, %rax, 1)" << ", " << "%eax" << endl;
                        asmOut << "\t" << setw(8) << "movl" << "%eax" << ", " << getStackLoc(result) << endl;
                    }
                } else if(op == "[]=") {
                    Sym *sym = curTable->lookup(result);
                    if(sym->category == Sym::PARAMETER) {
                        asmOut << "\t" << setw(8) << "movl" << getStackLoc(arg1) << ", " << "%eax" << endl;
                        asmOut << "\t" << setw(8) << "cltq" << endl;
                        asmOut << "\t" << setw(8) << "addq" << getStackLoc(result) << ", " << "%rax" << endl;
                        asmOut << "\t" << setw(8) << "movl" << getStackLoc(arg2) << ", " << "%ebx" << endl;
                        asmOut << "\t" << setw(8) << "movl" << "%ebx" << ", " << "(%rax)" << endl;
                    } else {
                        asmOut << "\t" << setw(8) << "movl" << getStackLoc(arg1) << ", " << "%eax" << endl;
                        asmOut << "\t" << setw(8) << "cltq" << endl;
                        asmOut << "\t" << setw(8) << "movl" << getStackLoc(arg2) << ", " << "%ebx" << endl;
                        asmOut << "\t" << setw(8) << "movl" << "%ebx" << ", " << curAR->offset[result] << "(%rbp, %rax, 1)" << endl;
                    }
                } else if(op == "=&") {
                    asmOut << "\t" << setw(8) << "leaq" << getStackLoc(arg1) << ", " << "%rax" << endl;
                    asmOut << "\t" << setw(8) << "movq" << "%rax" << ", " << getStackLoc(result) << endl;
                } else if(op == "=*") {
                    asmOut << "\t" << setw(8) << "movq" << getStackLoc(arg1) << ", " << "%rax" << endl;
                    asmOut << "\t" << setw(8) << "movl" << "(%rax)" << ", " << "%eax" << endl;
                    asmOut << "\t" << setw(8) << "movl" << "%eax" << ", " << getStackLoc(result) << endl;
                } else if(op == "=-") {
                    asmOut << "\t" << setw(8) << "movl" << getStackLoc(arg1) << ", " << "%eax" << endl;
                    asmOut << "\t" << setw(8) << "negl" << "%eax" << endl;
                    asmOut << "\t" << setw(8) << "movl" << "%eax" << ", " << getStackLoc(result) << endl;
                } else if(op == "*=") {
                    asmOut << "\t" << setw(8) << "movl" << getStackLoc(arg1) << ", " << "%eax" << endl;
                    asmOut << "\t" << setw(8) << "movq" << getStackLoc(result) << ", " << "%rbx" << endl;
                    asmOut << "\t" << setw(8) << "movl" << "%eax" << ", " << "(%rbx)" << endl;
                }
            } else {
                curSym = globalTable->lookup(quad->result);
                if(curSym->category == Sym::TEMPORARY) {
                    if(curSym->type->type == SymType::Int) {
                        globalIntTemp = stoi(quad->arg1);
                    } else if(curSym->type->type == SymType::Char) {
                        globalCharTemp = getAsciiValue(quad->arg1);
                    } else if(curSym->type->type == SymType::Pointer) {
                        globalStringTemp = ".LC" + quad->arg1;
                    }
                } else {
                    if(curSym->type->type == SymType::Int) {
                        asmOut << "\t" << setw(8) << ".globl" << curSym->name << endl;
                        asmOut << "\t" << setw(8) << ".data" << endl;
                        asmOut << "\t" << setw(8) << ".align" << 4 << endl;
                        asmOut << "\t" << setw(8) << ".type" << curSym->name << ", @object" << endl;
                        asmOut << "\t" << setw(8) << ".size" << curSym->name << ", 4" << endl;
                        asmOut << curSym->name << ":" << endl;
                        asmOut << "\t" << setw(8) << ".long" << globalIntTemp << endl;
                    } else if(curSym->type->type == SymType::Char) {
                        asmOut << "\t" << setw(8) << ".globl" << curSym->name << endl;
                        asmOut << "\t" << setw(8) << ".data" << endl;
                        asmOut << "\t" << setw(8) << ".type" << curSym->name << ", @object" << endl;
                        asmOut << "\t" << setw(8) << ".size" << curSym->name << ", 1" << endl;
                        asmOut << curSym->name << ":" << endl;
                        asmOut << "\t" << setw(8) << ".byte" << globalCharTemp << endl;
                    } else if(curSym->type->type == SymType::Pointer) {
                        asmOut << "\t" << ".section	.data.rel.local" << endl;
                        asmOut << "\t" << setw(8) << ".align" << 8 << endl;
                        asmOut << "\t" << setw(8) << ".type" << curSym->name << ", @object" << endl;
                        asmOut << "\t" << setw(8) << ".size" << curSym->name << ", 8" << endl;
                        asmOut << curSym->name << ":" << endl;
                        asmOut << "\t" << setw(8) << ".quad" << globalStringTemp << endl;
                    }
                }
            }
        }
        qNum++;
    }
    asmOut.close();
}

int main(int argc, char const *argv[]) {
    inpFile = string(argv[1]) + ".c";
    asmFile = string(argv[1]) + ".s";
    tableCnt = 0;
    tempCnt = 0;
    globalTable = new SymTable("global");
    curTable = globalTable;
    cout << left;
    yyin = fopen(inpFile.c_str(), "r");
    yyparse();
    globalTable->update();
    globalTable->print();
    finalBackpatch();
    int cntr = 1;
    for(auto it : qArray)
    {
        cout<<setw(4)<<cntr++<<": "; it->print();
    }
    translate();
    return 0;
}