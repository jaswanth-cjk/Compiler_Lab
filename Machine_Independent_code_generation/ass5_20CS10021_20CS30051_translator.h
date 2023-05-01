#ifndef _TRANSLATOR_H
#define _TRANSLATOR_H

#include <bits/stdc++.h>
using namespace std;

class SymType;
class SymTable;
class Sym;
class Label;
class Quad;
class Expression;
class Array_;
class Statement;

// Symbol type class ( type safe representation for the type of a symbol )
class SymType {
    public:
        enum typeEnum {Void, Char, Int, Float, Pointer, Function, Array, Block} type;
        int width;
        SymType *arrayType;

        SymType(typeEnum, SymType * = NULL, int = 1);
        int getSize();
        string toString();
};

// Symbol table class
class SymTable {
    public:
        string name;
        map<string, Sym> syms;
        SymTable *parent;
        
        SymTable(string = "NULL", SymTable * = NULL);
        Sym *lookup(string);
        void print();
        void update();
};

// Sym class ( represents a single symbol in the symbol table )
class Sym {
    public:
        string name;
        int size, offset;
        SymType *type;
        SymTable *nestedTable;
        string initialValue;
        bool isFunction; // indicates if the symbol represents a function or not, in case of function, type represents return type

        Sym(string, SymType::typeEnum = SymType::Int, string = "");
        Sym *update(SymType *);
        Sym *convert(SymType::typeEnum);
};

// Quad class ( represents a 3-address quad )
class Quad {
    public:
        string op, arg1, arg2, result;  // parameters of the quad

        Quad(string, string, string = "=", string = "");
        Quad(string, int, string = "=", string = "");
        void print();
};

// Expression attributes
class Expression {
    public:
        Sym *sym;  // symbol of the expression
        enum typeEnum {NONboolean, boolean} type;
        list<int> trueList, falseList, nextList;

        void toInt();
        void toBool();
};

// Array attributes
class Array_ {
    public:
        Sym *temp;    // temporary for computing the offset for the array reference
        enum typeEnum {Other, Pointer, Array} type;
        Sym *sym;  // pointer to the symbol table entry
        SymType *subArrayType;   // type of sub-array generated
};

// Statement attributes
class Statement {
    public:
        list<int> nextList;     // List of quads having dangling exits for this statement
};

// Emit functions for generating quads
void emit(string, string, string = "", string = "");
void emit(string, string, int, string = "");

// Backpatching functions
void backpatch(list<int>, int);
list<int> makeList(int);
list<int> merge(list<int>, list<int>);

int nextInstr();
Sym *gentemp(SymType::typeEnum, string = "");
void changeTable(SymTable *);

bool typeCheck(Sym *&, Sym *&);

string toString(int);
string toString(float);
string toString(char);

extern vector<Quad *> qArray;
extern SymTable *curTable, *globalTable;
extern Sym *curSym;
extern SymType::typeEnum curType;
extern int tableCnt, tempCnt; // counters for symbol table and temporary symbols

extern int yyparse();

#endif