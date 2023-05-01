#include "ass5_20CS10021_20CS30051_translator.h"

// Global Variables
vector<Quad *> qArray;  // Quad Array
SymTable *curTable, *globalTable, *parentTable;  // Symbol Tables
Sym *curSym;  // Current Symbol
SymType::typeEnum curType;  // Current Type
int tableCnt, tempCnt;  // Counts of number of tables and number of temporaries generated

// Implementation of sym type class
SymType::SymType(typeEnum type, SymType *arrayType, int width) : type(type), width(width), arrayType(arrayType) {}

// Implementation of sizes for sym types
int SymType::getSize()
{
    if (type == Char)
        return 1;
    else if (type == Int || type == Pointer)
        return 4;
    else if (type == Float)
        return 8;
    else if (type == Array)
        return width * (arrayType->getSize());
    else
        return 0;
}

// Function to print sym type
string SymType::toString()
{
    if(this->type == SymType::Void)
        return "void";
    else if(this->type == SymType::Char)
        return "char";
    else if(this->type == SymType::Int)
        return "int";
    else if(this->type == SymType::Float)
        return "float";
    else if(this->type == SymType::Pointer)
        return "ptr(" + this->arrayType->toString() + ")";
    else if(this->type == SymType::Function)
        return "function";
    else if(this->type == SymType::Array)
        return "array(" + to_string(this->width) + ", " + this->arrayType->toString() + ")";
    else if(this->type ==  SymType::Block)
        return "block";
}

// Implementation of sym table class
SymTable::SymTable(string name, SymTable *parent) : name(name), parent(parent) {}

Sym *SymTable::lookup(string name)
{
    auto it = (this)->syms.find(name);
    if (it != (this)->syms.end())
        return &(it->second);
    Sym *ret_ptr = nullptr;
    if (this->parent != NULL)
        ret_ptr = this->parent->lookup(name);
    if (this == curTable && !ret_ptr)
    {
        this->syms.insert({name, *(new Sym(name))});
        return &((this)->syms.find(name)->second);
    }
    return ret_ptr;
}

// Update the sym table and its children with offsets
void SymTable::update()
{
    vector<SymTable *> visited;
    int offset;
    for (auto &map_entry : (this)->syms)
    {
        if (map_entry.first == (this->syms).begin()->first)
        {
            map_entry.second.offset = 0;
            offset = map_entry.second.size;
        }
        else
        {
            map_entry.second.offset = offset;
            offset += map_entry.second.size;
        }
        if (map_entry.second.nestedTable)
        {
            visited.push_back(map_entry.second.nestedTable);
        }
    }
    for (auto &table : visited)
    {
        table->update();
    }
}

// Function to print the symbol table and its children
void SymTable::print()
{
    cout << "Table Name: " << this->name <<"\t\t Parent Name: "<< ((this->parent)? this->parent->name : "None") << endl;
    cout << setw(20) << "Name" << setw(40) << "Type" << setw(20) << "Initial Value" << setw(20) << "Offset" << setw(20) << "Size" << setw(20) << "Child" << "\n" << endl;
    vector<SymTable *> new_tables;      //for nested tables

    for (auto &map_entry : (this)->syms)
    {
        cout << setw(20) << map_entry.first;
        fflush(stdout);
        cout << setw(40) << (map_entry.second.isFunction ? "function" : map_entry.second.type->toString());
        cout << setw(20) << map_entry.second.initialValue << setw(20) << map_entry.second.offset << setw(20) << map_entry.second.size;
        cout << setw(20) << (map_entry.second.nestedTable ? map_entry.second.nestedTable->name : "NULL") << endl;
        if (map_entry.second.nestedTable)
        {
            new_tables.push_back(map_entry.second.nestedTable);
        }
    }
    cout << "\n\n" << endl;
    for (auto &table : new_tables)
    {
        table->print();
    }
}

// Implementation of sym class
Sym::Sym(string name, SymType::typeEnum type, string init) : name(name), type(new SymType(type)), offset(0), nestedTable(NULL), initialValue(init), isFunction(false)
{
    size = this->type->getSize();
}
//update type of the sym
Sym *Sym::update(SymType *type)
{
    this->type = type;
    size = this->type->getSize();
    return this;
}
//convert the present symbol to different type, return old symbol if conversion not possible 
Sym *Sym::convert(SymType::typeEnum type_)
{
    if ((this->type)->type == SymType::typeEnum::Float)
    {
        if (type_ == SymType::typeEnum::Int)
        {
            Sym *fin_ = gentemp(type_);
            emit("=", fin_->name, "Float_TO_Int(" + this->name + ")");
            return fin_;
        }
        else if (type_ == SymType::typeEnum::Char)
        {
            Sym *fin_ = gentemp(type_);
            emit("=", fin_->name, "Float_TO_Char(" + this->name + ")");
            return fin_;
        }
        return this;
    }
    else if ((this->type)->type == SymType::typeEnum::Int)
    {
        if (type_ == SymType::typeEnum::Float)
        {
            Sym *fin_ = gentemp(type_);
            emit("=", fin_->name, "Int_TO_Float(" + this->name + ")");
            return fin_;
        }
        else if (type_ == SymType::typeEnum::Char)
        {
            Sym *fin_ = gentemp(type_);
            emit("=", fin_->name, "Int_TO_Char(" + this->name + ")");
            return fin_;
        }
        return this;
    }
    else if ((this->type)->type == SymType::typeEnum::Char)
    {
        if (type_ == SymType::typeEnum::Int)
        {
            Sym *fin_ = gentemp(type_);
            emit("=", fin_->name, "Char_TO_Int(" + this->name + ")");
            return fin_;
        }
        else if (type_ == SymType::typeEnum::Float)
        {
            Sym *fin_ = gentemp(type_);
            emit("=", fin_->name, "Char_TO_Float(" + this->name + ")");
            return fin_;
        }
        return this;
    }
    return this;
}

// Implementation of quad class
Quad::Quad(string result, string arg1, string op, string arg2) : result(result), op(op), arg1(arg1), arg2(arg2) {}
Quad::Quad(string result, int arg1, string op, string arg2) : result(result), op(op), arg1(toString(arg1)), arg2(arg2) {}

// print the quad 
void Quad::print()
{
    // binary operations
    auto binary_print = [this]()
    {
        cout << "\t" << this->result << " = " << this->arg1 << " " << this->op << " " << this->arg2 << endl;
    };
    // relational operators
    auto relation_print = [this]()
    {
        cout << "\tif " << this->arg1 << " " << this->op << " " << this->arg2 << " goto " << this->result << endl;
    };
    // shift operators
    auto shift_print = [this]()
    {
        cout << "\t" << this->result << " " << this->op[0] << " " << this->op[1] << this->arg1 << endl;
    };
    auto shift_print_ = [this](string tp)
    {
        cout << "\t" << this->result << " " << tp << " " << this->arg1 << endl;
    };

    // printing format for all operators
    if (this->op == "=")
    {
        cout << "\t" << this->result << " = " << this->arg1 << endl;
    }
    else if (this->op == "goto")
    {
        cout << "\tgoto " << this->result << endl;
    }
    else if (this->op == "return")
    {
        cout << "\treturn " << this->result << endl;
    }
    else if (this->op == "call")
    {
        cout << "\t" << this->result << " = call " << this->arg1 << ", " << this->arg2 << endl;
    }
    else if (this->op == "param")
    {
        cout << "\t" << "param " << this->result << endl;
    }
    else if (this->op == "label")
    {
        cout << this->result << endl;
    }
    else if (this->op == "=[]")
    {
        cout << "\t" << this->result << " = " << this->arg1 << "[" << this->arg2 << "]" << endl;
    }
    else if (this->op == "[]=")
    {
        cout << "\t" << this->result << "[" << this->arg1 << "] = " << this->arg2 << endl;
    }
    else if (this->op == "+" || this->op == "-" || this->op == "*" || this->op == "/" || this->op == "%" || this->op == "|" || this->op == "^" || this->op == "&" || this->op == "<<" || this->op == ">>")
    {
        binary_print();
    }
    else if (this->op == "==" || this->op == "!=" || this->op == "<" || this->op == ">" || this->op == "<=" || this->op == ">=")
    {
        relation_print();
    }
    else if (this->op == "=&" || this->op == "=*")
    {
        shift_print();
    }
    else if(this->op == "*=")
    {
        cout << "\t" << "*" << this->result << " = " << this->arg1 << endl;
    }
    else if (this->op == "=-")
    {
        shift_print_("= -");
    }
    else if (this->op == "~")
    {
        shift_print_("= ~");
    }
    else if (this->op == "!")
    {
        shift_print_("= !");
    }
    else
    {
        cout << this->op << this->arg1 << this->arg2 << this->result << endl;
        cout << "Invalid Operator" << endl;
    }
}

// Implementation of emit funtions
void emit(string op, string result, string arg1, string arg2)
{
    Quad *q = new Quad(result, arg1, op, arg2);
    qArray.push_back(q);
}
void emit(string op, string result, int arg1, string arg2)
{
    Quad *q = new Quad(result, arg1, op, arg2);
    qArray.push_back(q);
}

// Implementation of backpatching functions
void backpatch(list<int> list_, int addr)
{
    for (auto &i : list_)
    {
        qArray[i-1]->result = toString(addr);
    }
}

list<int> makeList(int base)
{
    // returns list with the base address as its only value
    return {base};
}

list<int> merge(list<int> first, list<int> second)
{
    list<int> ret = first;
    ret.merge(second);
    return ret;
}

// Implementation of Expression class functions
void Expression::toInt()
{
    if (this->type == Expression::typeEnum::boolean)
    {
        this->sym = gentemp(SymType::typeEnum::Int);
        backpatch(this->trueList, static_cast<int>(qArray.size()+1));
        emit("=", this->sym->name, "true");
        emit("goto", toString(static_cast<int>(qArray.size() + 2)));
        backpatch(this->falseList, static_cast<int>(qArray.size()+1));
        emit("=", this->sym->name, "false");
    }
}

void Expression::toBool()
{
    if (this->type == Expression::typeEnum::NONboolean)
    {
        this->falseList = makeList(static_cast<int>(qArray.size()+1));
        emit("==", "", this->sym->name, "0");
        this->trueList = makeList(static_cast<int>(qArray.size()+1));
        emit("goto", "");
    }
}

int nextInstr()
{
    return qArray.size() + 1;
}

//generates temporary of given type with given value s
Sym *gentemp(SymType::typeEnum type, string s)
{
    Sym *temp = new Sym("t" + toString(tempCnt++), type, s);
    curTable->syms.insert({temp->name, *temp});
    return temp;
}

//change current table to the specified table
void changeTable(SymTable *table)
{
    curTable = table;
}

//for checking if types are, if not then higher promotion is done to same types if possible
bool typeCheck(Sym *&a, Sym *&b)
{
    std::function<bool(SymType *, SymType *)> type_comp = [&](SymType *first, SymType *second) -> bool
    {
        if (!first && !second)
            return true;
        else if (!first || !second || first->type != second->type)
            return false;
        else
            return type_comp(first->arrayType, second->arrayType);
    };
    if(type_comp(a->type, b->type))
        return true;
    else if(a->type->type == SymType::Float || b->type->type == SymType::Float) {
        a = a->convert(SymType::Float);
        b = b->convert(SymType::Float);
        return true;
    }
    else if(a->type->type == SymType::Int || b->type->type == SymType::Int) {
        a = a->convert(SymType::Int);
        b = b->convert(SymType::Int);
        return true;
    }
    else {
        return false;
    }
}

string toString(int i)
{
    return to_string(i);
}

string toString(float f)
{
    return to_string(f);
}

string toString(char c)
{
    return string(1, c);
}

int main() 
{
    tableCnt = 0;
    tempCnt = 0;
    globalTable = new SymTable("global");
    curTable = globalTable;
    cout << left;
    yyparse();
    globalTable->update();
    globalTable->print();
    int cntr = 1;
    for(auto it : qArray) {
        cout<<setw(4)<<cntr++<<": "; it->print();
    }
    return 0;
}