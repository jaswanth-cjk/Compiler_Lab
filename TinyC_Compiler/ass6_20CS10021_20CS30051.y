%{
    #include "ass6_20CS10021_20CS30051_translator.h"
    extern int yylex();
    void yyerror(char* s);
%}

%union {
    int intval;
    char* floatval;
    char* charval;
    char* stringval;
    char* unaryOperator;
    int instructionNumber;
    int parameterCount;
    Expression *expression;
    Statement *statement;
    Array_ *array;
    SymType *symType;
    Sym *sym;
}

%token AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE
%token ELSE ENUM EXTERN FLOAT FOR GOTO IF INLINE INT LONG
%token REGISTER RESTRICT RETURN SHORT SIGNED SIZEOF STATIC STRUCT SWITCH
%token TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE BOOL COMPLEX IMAGINARY 

%token <sym> IDENTIFIER
%token <stringval> STRING_LITERAL
%token <intval> INT_CONST
%token <floatval> FLOAT_CONST
%token <charval> CHAR_CONST

%token LSQ RSQ LPAR RPAR LCUR RCUR DOT ARROW INCREMENT DECREMENT
%token BIN_AND MULT PLUS MINUS TILDE NOT SLASH MOD LT GT BIN_XOR BIN_OR
%token RSHIFT LSHIFT LEQ GEQ EQ NEQ OR AND ELLIPSIS QMARK COLON SEMICOLON
%token ASSIGN MULT_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN SUB_ASSIGN LSHIFT_ASSIGN
%token RSHIFT_ASSIGN BIN_AND_ASSIGN BIN_XOR_ASSIGN BIN_OR_ASSIGN COMMA HASH

%nonassoc RPAR
%nonassoc ELSE
%start translation_unit

%type<unaryOperator> 
    unary_operator

%type<parameterCount> 
    argument_expression_list 
    argument_expression_list_opt

%type<expression>
	expression
	primary_expression 
	multiplicative_expression
	additive_expression
	shift_expression
	relational_expression
	equality_expression
	AND_expression
	exclusive_OR_expression
	inclusive_OR_expression
	logical_AND_expression
	logical_OR_expression
	conditional_expression
	assignment_expression
	expression_statement
    expression_opt

%type<array> 
    postfix_expression
	unary_expression
	cast_expression

%type<statement>  
    statement
	compound_statement
	selection_statement
	iteration_statement
	labeled_statement 
	jump_statement
	block_item
	block_item_list
	block_item_list_opt
    N

%type<symType> 
    pointer

%type<sym>
    initializer
    direct_declarator 
    init_declarator 
    declarator

%type<instructionNumber> 
    M

%%

//Expressions
primary_expression:
                    IDENTIFIER
                    {
                        $$ = new Expression();
                        $$->sym = $1;
                        $$->type = Expression::NONboolean;
                    }
                    | INT_CONST
                    {
                        $$ = new Expression();
                        $$->sym = gentemp(SymType::Int, toString($1));
                        emit("=", $$->sym->name, $1);
                    }
                    | FLOAT_CONST
                    {
                        $$ = new Expression();
                        $$->sym = gentemp(SymType::Float, $1);
                        emit("=", $$->sym->name, $1);
                    }
                    | CHAR_CONST
                    {
                        $$ = new Expression();
                        $$->sym = gentemp(SymType::Char, $1);
                        emit("=", $$->sym->name, $1);
                    }
                    | STRING_LITERAL
                    {
                        $$ = new Expression();
		                $$->sym = gentemp(SymType::Pointer, $1);
		                $$->sym->type->arrayType = new SymType(SymType::Char);
                        emit("=str", $$->sym->name, strLiterals.size());	
                        strLiterals.push_back($1);
                    }
                    | LPAR expression RPAR
                    { $$ = $2; }
                    ;

postfix_expression:
                    primary_expression
                    {
                        $$ = new Array_();
                        $$->sym = $1->sym;
                        $$->temp = $$->sym;
                        $$->subArrayType = $1->sym->type;
                    }
                    | postfix_expression LSQ expression RSQ
                    {
                         $$ = new Array_();
                        $$->sym = $1->sym;
                        $$->subArrayType = $1->subArrayType->arrayType;
                        $$->temp = gentemp(SymType::Int);
                        $$->type = Array_::Array;
                        if($1->type == Array_::Array) {
                            Sym *sym = gentemp(SymType::Int);
                            emit("*", sym->name, $3->sym->name, toString($$->subArrayType->getSize()));
                            emit("+", $$->temp->name, $1->temp->name, sym->name);
                        } else {
                            emit("*", $$->temp->name, $3->sym->name, toString($$->subArrayType->getSize()));
                        }
                    }
                    | postfix_expression LPAR argument_expression_list_opt RPAR
                    {
                        $$ = new Array_();
                        $$->sym = gentemp($1->sym->type->type);
                        $$->sym->type->arrayType = $1->sym->type->arrayType;
                        emit("call", $$->sym->name, $1->sym->name, toString($3));
                    }
                    | postfix_expression DOT IDENTIFIER
                    | postfix_expression ARROW IDENTIFIER
                    | postfix_expression INCREMENT
                    {
                        $$ = new Array_();
                        $$->sym = gentemp($1->sym->type->type);
                        emit("=", $$->sym->name, $1->sym->name);
                        emit("+", $1->sym->name, $1->sym->name, toString(1));
                    }
                    | postfix_expression DECREMENT
                    {
                        $$ = new Array_();
                        $$->sym = gentemp($1->sym->type->type);
                        emit("=", $$->sym->name, $1->sym->name);
                        emit("-", $1->sym->name, $1->sym->name, toString(1));
                    }
                    | LPAR type_name RPAR LCUR initializer_list RCUR
                    {}
                    | LPAR type_name RPAR LCUR initializer_list COMMA RCUR
                    {}
                    ;  

argument_expression_list:
                            assignment_expression
                            {
                                emit("param", $1->sym->name);
                                $$ = 1;
                            }
                            | argument_expression_list COMMA assignment_expression   
                            {
                                emit("param", $3->sym->name);
                                $$ = $1 + 1; 
                            }
                            ;

argument_expression_list_opt:
                                argument_expression_list
                                { $$ = $1; }
                                |
                                { $$ = 0; }
                                ;

unary_expression:
                    postfix_expression
                    { $$ = $1; }
                    | INCREMENT unary_expression
                    {
                        $$ = $2;
                        emit("+", $2->sym->name, $2->sym->name, toString(1));
                    }
                    | DECREMENT unary_expression
                    {
                        $$ = $2;
                        emit("-", $2->sym->name, $2->sym->name, toString(1));
                    }
                    | unary_operator cast_expression
                    {
                        if(strcmp($1, "&") == 0) {
                            $$ = new Array_();
                            $$->sym = gentemp(SymType::Pointer);
                            $$->sym->type->arrayType = $2->sym->type;
                            emit("=&", $$->sym->name, $2->sym->name);
                        } else if(strcmp($1, "*") == 0) {
                            $$ = new Array_();
                            $$->sym = $2->sym;
                            $$->temp = gentemp($2->temp->type->arrayType->type);
                            $$->temp->type->arrayType = $2->temp->type->arrayType->arrayType;
                            $$->type = Array_::Pointer;
                            emit("=*", $$->temp->name, $2->temp->name);
                        } else if(strcmp($1, "+") == 0) {
                            $$ = $2;
                        } else {
                            $$ = new Array_();
                            $$->sym = gentemp($2->sym->type->type);
                            emit($1, $$->sym->name, $2->sym->name);
                        }
                    }
                    | SIZEOF unary_expression
                    {}
                    | SIZEOF LPAR type_name RPAR
                    {}
                    ;    

unary_operator: 
                BIN_AND 
                { $$ = strdup("&"); }
                | MULT
                { $$ = strdup("*"); }
                | PLUS 
                { $$ = strdup("+"); }
                | MINUS
                { $$ = strdup("-"); }
                | TILDE
                { $$ = strdup("~"); }
                | NOT
                { $$ = strdup("!"); }
                ;

cast_expression:
                    unary_expression
                    { $$ = $1; }
                    | LPAR type_name RPAR cast_expression
                    {
                        $$ = new Array_();
                        $$->sym = $4->sym->convert(curType);
                    }
                    ;

multiplicative_expression:
                            cast_expression
                            {
                                SymType *baseType = $1->sym->type;
                                while(baseType->arrayType) baseType = baseType->arrayType;
                                $$ = new Expression();
                                if($1->type == Array_::Array) {
                                    $$->sym = gentemp(baseType->type);
                                    emit("=[]", $$->sym->name, $1->sym->name, $1->temp->name);
                                } else if($1->type == Array_::Pointer) {
                                    $$->sym = $1->temp;
                                } else {
                                    $$->sym = $1->sym;
                                }
                            }
                            | multiplicative_expression MULT cast_expression
                            {
                                SymType *baseType = $3->sym->type;
                                while(baseType->arrayType) baseType = baseType->arrayType;
                                Sym *temp;
                                if($3->type == Array_::Array) {
                                    temp = gentemp(baseType->type);
                                    emit("=[]", temp->name, $3->sym->name, $3->temp->name);
                                } else if($3->type == Array_::Pointer) {
                                    temp = $3->temp;
                                } else {
                                    temp = $3->sym;
                                } 
                                if(typeCheck($1->sym, temp)) {
                                    $$ = new Expression();
                                    $$->sym = gentemp($1->sym->type->type);
                                    emit("*", $$->sym->name, $1->sym->name, temp->name);
                                }
                            }
                            | multiplicative_expression SLASH cast_expression
                            {
                                SymType *baseType = $3->sym->type;
                                while(baseType->arrayType) baseType = baseType->arrayType;
                                Sym *temp;
                                if($3->type == Array_::Array) {
                                    temp = gentemp(baseType->type);
                                    emit("=[]", temp->name, $3->sym->name, $3->temp->name);
                                } else if($3->type == Array_::Pointer) {
                                    temp = $3->temp;
                                } else {
                                    temp = $3->sym;
                                }
                                if(typeCheck($1->sym, temp)) {
                                    $$ = new Expression();
                                    $$->sym = gentemp($1->sym->type->type);
                                    emit("/", $$->sym->name, $1->sym->name, temp->name);
                                }
                            }
                            | multiplicative_expression MOD cast_expression     
                            {
                                SymType *baseType = $3->sym->type;
                                while(baseType->arrayType) baseType = baseType->arrayType;
                                Sym *temp;
                                if($3->type == Array_::Array) {
                                    temp = gentemp(baseType->type);
                                    emit("=[]", temp->name, $3->sym->name, $3->temp->name);
                                } else if($3->type == Array_::Pointer) {
                                    temp = $3->temp;
                                } else {
                                    temp = $3->sym;
                                }
                                if(typeCheck($1->sym, temp)) {
                                    $$ = new Expression();
                                    $$->sym = gentemp($1->sym->type->type);
                                    emit("%", $$->sym->name, $1->sym->name, temp->name);
                                }
                            }
                            ;

additive_expression:        
                        multiplicative_expression
                        { $$ = $1; }
                        | additive_expression PLUS multiplicative_expression
                        {
                            if(typeCheck($1->sym, $3->sym)) {
                                $$ = new Expression();
                                $$->sym = gentemp($1->sym->type->type);
                                emit("+", $$->sym->name, $1->sym->name, $3->sym->name);
                            }
                        }
                        | additive_expression MINUS multiplicative_expression
                        {
                            if(typeCheck($1->sym, $3->sym)) {
                                $$ = new Expression();
                                $$->sym = gentemp($1->sym->type->type);
                                emit("-", $$->sym->name, $1->sym->name, $3->sym->name);
                            }
                        }
                        ;

shift_expression:
                    additive_expression
                    { $$ = $1; }
                    | shift_expression LSHIFT additive_expression
                    {
                        if($3->sym->type->type == SymType::Int) {
                            $$ = new Expression();
                            $$->sym = gentemp(SymType::Int);
                            emit("<<", $$->sym->name, $1->sym->name, $3->sym->name);
                        }
                    }
                    | shift_expression RSHIFT additive_expression
                    {
                        if($3->sym->type->type == SymType::Int) {
                            $$ = new Expression();
                            $$->sym = gentemp(SymType::Int);
                            emit(">>", $$->sym->name, $1->sym->name, $3->sym->name);
                        }
                    }
                    ;

relational_expression:
                        shift_expression
                        { $$ = $1; }
                        | relational_expression LT shift_expression
                        {
                            if(typeCheck($1->sym, $3->sym)) {
                                $$ = new Expression();
                                $$->type = Expression::boolean;
                                $$->trueList = makeList(nextInstr());
                                $$->falseList = makeList(nextInstr() + 1);
                                emit("<", "", $1->sym->name, $3->sym->name);
                                emit("goto", "");
                            }
                        }
                        | relational_expression GT shift_expression
                        {
                            if(typeCheck($1->sym, $3->sym)) {
                                $$ = new Expression();
                                $$->type = Expression::boolean;
                                $$->trueList = makeList(nextInstr());
                                $$->falseList = makeList(nextInstr() + 1);
                                emit(">", "", $1->sym->name, $3->sym->name);
                                emit("goto", "");
                            }
                        }
                        | relational_expression LEQ shift_expression
                        {
                            if(typeCheck($1->sym, $3->sym)) {
                                $$ = new Expression();
                                $$->type = Expression::boolean;
                                $$->trueList = makeList(nextInstr());
                                $$->falseList = makeList(nextInstr() + 1);
                                emit("<=", "", $1->sym->name, $3->sym->name);
                                emit("goto", "");
                            }
                        }
                        | relational_expression GEQ shift_expression
                        {
                            if(typeCheck($1->sym, $3->sym)) {
                                $$ = new Expression();
                                $$->type = Expression::boolean;
                                $$->trueList = makeList(nextInstr());
                                $$->falseList = makeList(nextInstr() + 1);
                                emit(">=", "", $1->sym->name, $3->sym->name);
                                emit("goto", "");
                            }
                        }
                        ;

equality_expression:
                        relational_expression
                        { $$ = $1; }
                        | equality_expression EQ relational_expression
                        {
                            if(typeCheck($1->sym, $3->sym)) {
                                $1->toInt();
                                $3->toInt();
                                $$ = new Expression();
                                $$->type = Expression::boolean;
                                $$->trueList = makeList(nextInstr());
			                    $$->falseList = makeList(nextInstr() + 1);
                                emit("==", "", $1->sym->name, $3->sym->name);
                                emit("goto", "");
                            }
                        }
                        | equality_expression NEQ relational_expression
                        {
                            if(typeCheck($1->sym, $3->sym)) {
                                $1->toInt();
                                $3->toInt();
                                $$ = new Expression();
                                $$->type = Expression::boolean;
                                $$->trueList = makeList(nextInstr());
			                    $$->falseList = makeList(nextInstr() + 1);
                                emit("!=", "", $1->sym->name, $3->sym->name);
                                emit("goto", "");
                            }
                        }
                        ;

AND_expression:
                equality_expression
                { $$ = $1; }
                | AND_expression BIN_AND equality_expression
                {
                    $1->toInt();
                    $3->toInt();
                    $$ = new Expression();
                    $$->type = Expression::NONboolean;
                    $$->sym = gentemp(SymType::Int);
                    emit("&", $$->sym->name, $1->sym->name, $3->sym->name);
                }
                ;

exclusive_OR_expression:
                            AND_expression
                            { $$ = $1; }
                            | exclusive_OR_expression BIN_XOR AND_expression
                            {
                                $1->toInt();
                                $3->toInt();
                                $$ = new Expression();
                                $$->type = Expression::NONboolean;
                                $$->sym = gentemp(SymType::Int);
                                emit("^", $$->sym->name, $1->sym->name, $3->sym->name);
                            }
                            ;

inclusive_OR_expression:
                            exclusive_OR_expression
                            { $$ = $1; }
                            | inclusive_OR_expression BIN_OR exclusive_OR_expression
                            {
                                $1->toInt();
                                $3->toInt();
                                $$ = new Expression();
                                $$->type = Expression::NONboolean;
                                $$->sym = gentemp(SymType::Int);
                                emit("|", $$->sym->name, $1->sym->name, $3->sym->name);
                            }
                            ;

M:  
    { $$ = nextInstr(); }
    ;

N: 
    {
        $$ = new Statement();
        $$->nextList = makeList(nextInstr());
        emit("goto", "");
    }
	;

logical_AND_expression:
                        inclusive_OR_expression
                        { $$ = $1; }
                        | logical_AND_expression AND M inclusive_OR_expression
                        {
                            $1->toBool();
                            $4->toBool();
                            $$ = new Expression();
                            $$->type = Expression::boolean;
                            backpatch($1->trueList, $3);
                            $$->trueList = $4->trueList;
                            $$->falseList = merge($1->falseList, $4->falseList);
                        }
                        ;

logical_OR_expression:
                        logical_AND_expression
                        { $$ = $1; }
                        | logical_OR_expression OR M logical_AND_expression
                        {
                            $1->toBool();
                            $4->toBool();
                            $$ = new Expression();
                            $$->type = Expression::boolean;
                            backpatch($1->falseList, $3);
                            $$->trueList = merge($1->trueList, $4->trueList);
                            $$->falseList = $4->falseList;
                        }
                        ;

conditional_expression:
                        logical_OR_expression
                        { $$ = $1; }
                        | logical_OR_expression N QMARK M expression N COLON M conditional_expression
                        {
                            printf("reached\n");
                            $$->sym = gentemp($5->sym->type->type);
                            $$->sym->update($5->sym->type);
                            emit("=", $$->sym->name, $9->sym->name);
                            list<int> l = makeList(nextInstr());
                            emit("goto", "");
                            backpatch($6->nextList, nextInstr());
                            emit("=", $$->sym->name, $5->sym->name);
                            l = merge(l, makeList(nextInstr()));
                            emit("goto", "");
                            backpatch($2->nextList, nextInstr());
                            $1->toBool();
                            backpatch($1->trueList, $4);
                            backpatch($1->falseList, $8);
                            backpatch(l, nextInstr());
                        }
                        ;

assignment_expression:
                        conditional_expression
                        { $$ = $1; }
                        | unary_expression assignment_operator assignment_expression
                        {
                            if($1->type == Array_::Array) {
                                $3->sym = $3->sym->convert($1->subArrayType->type);
                                emit("[]=", $1->sym->name, $1->temp->name, $3->sym->name);
                            } else if($1->type == Array_::Pointer) {
                                $3->sym = $3->sym->convert($1->temp->type->type);
                                emit("*=", $1->temp->name, $3->sym->name);
                            } else {
                                $3->sym = $3->sym->convert($1->sym->type->type);
                                emit("=", $1->sym->name, $3->sym->name);
                            }
                            $$ = $3;
                        }
                        ;

assignment_operator: 
                        ASSIGN
                        | MULT_ASSIGN
                        | DIV_ASSIGN
                        | MOD_ASSIGN
                        | ADD_ASSIGN
                        | SUB_ASSIGN
                        | LSHIFT_ASSIGN
                        | RSHIFT_ASSIGN
                        | BIN_AND_ASSIGN
                        | BIN_XOR_ASSIGN
                        | BIN_OR_ASSIGN
                        ;

expression:
            assignment_expression
            { $$ = $1; }
            | expression COMMA assignment_expression
            ;

constant_expression:
                        conditional_expression
                        ;

//Declarations
declaration:
                declaration_specifiers init_declarator_list_opt SEMICOLON
                ;

init_declarator_list_opt:
                            init_declarator_list
                            |
                            ;

declaration_specifiers:
                        storage_class_specifier declaration_specifiers_opt
                        | type_specifier declaration_specifiers_opt
                        | type_qualifier declaration_specifiers_opt
                        | function_specifier declaration_specifiers_opt
                        ;

declaration_specifiers_opt:
                            declaration_specifiers
                            |
                            ;

init_declarator_list:
                        init_declarator
                        | init_declarator_list COMMA init_declarator
                        ;

init_declarator:
                    declarator
                    { $$ = $1; }
                    | declarator ASSIGN initializer
                    {
                        if($3->initialValue != "") 
                            $1->initialValue = $3->initialValue;
		                emit("=", $1->name, $3->name);
                    }
                    ;

storage_class_specifier:
                            EXTERN
                            | STATIC
                            | AUTO
                            | REGISTER
                            ;

type_specifier:
                VOID
                { curType = SymType::Void; }
                | CHAR
                { curType = SymType::Char; }
                | SHORT
                | INT
                { curType = SymType::Int; }
                | LONG
                | FLOAT
                { curType = SymType::Float; }
                | DOUBLE
                | SIGNED
                | UNSIGNED
                | BOOL
                | COMPLEX
                | IMAGINARY
                | enum_specifier
                ;

specifier_qualifier_list:
                            type_specifier specifier_qualifier_list_opt
                            | type_qualifier specifier_qualifier_list_opt
                            ;

specifier_qualifier_list_opt:
                                specifier_qualifier_list
                                |
                                ;

enum_specifier:
                ENUM identifier_opt LCUR enumerator_list RCUR
                | ENUM identifier_opt LCUR enumerator_list COMMA RCUR
                | ENUM IDENTIFIER
                ;

identifier_opt:
                IDENTIFIER
                |
                ;

enumerator_list:
                enumerator
                | enumerator_list COMMA enumerator
                ;

enumerator:
            IDENTIFIER
            | IDENTIFIER ASSIGN constant_expression
            ;

type_qualifier:
                CONST
                | RESTRICT
                | VOLATILE
                ;

function_specifier:
                    INLINE
                    ;

declarator:
            pointer direct_declarator
            {
                SymType *it = $1;
                while(it->arrayType != NULL) 
                    it = it->arrayType;
                it->arrayType = $2->type;
                $$ = $2->update($1);
            }
            | direct_declarator
            ;

direct_declarator:
                    IDENTIFIER
                    {
                        $$ = $1->update(new SymType(curType));
                        curSym = $$;
                    }
                    | LPAR declarator RPAR
                    { $$ = $2; }
                    | direct_declarator LSQ type_qualifier_list assignment_expression RSQ
                    | direct_declarator LSQ type_qualifier_list RSQ
                    | direct_declarator LSQ assignment_expression RSQ
                    { 
                        SymType *it1 = $1->type, *it2 = NULL;
                        while(it1->type == SymType::Array) {
                            it2 = it1;
                            it1 = it1->arrayType;
                        }
                        if(it2 != NULL) {
                            it2->arrayType =  new SymType(SymType::Array, it1, atoi($3->sym->initialValue.c_str()));	
                            $$ = $1->update($1->type);
                        }
                        else {
                                $$ = $1->update(new SymType(SymType::Array, $1->type, atoi($3->sym->initialValue.c_str())));
                        }
                    }
                    | direct_declarator LSQ RSQ
                    {
                        SymType *it1 = $1->type, *it2 = NULL;
                        while(it1->type == SymType::Array) {
                            it2 = it1;
                            it1 = it1->arrayType;
                        }
                        if(it2 != NULL) {
                            it2->arrayType =  new SymType(SymType::Array, it1, 0);	
                            $$ = $1->update($1->type);
                        }
                        else {
                            $$ = $1->update(new SymType(SymType::Array, $1->type, 0));
                        }
                    }
                    | direct_declarator LSQ STATIC type_qualifier_list_opt assignment_expression RSQ
                    {}
                    | direct_declarator LSQ type_qualifier_list STATIC assignment_expression RSQ
                    {}
                    | direct_declarator LSQ type_qualifier_list_opt MULT RSQ
                    {}
                    | direct_declarator LPAR new_scope parameter_type_list RPAR
                    {
                        curTable->name = $1->name;
                        if($1->type->type != SymType::Void) {
                            curTable->lookup("return")->update($1->type);
                        }
                        $1->nestedTable = curTable;
                        $1->category = Sym::FUNCTION;
                        curTable->parent = globalTable;
                        changeTable(globalTable);
                        curSym = $$;
                    }
                    | direct_declarator LPAR identifier_list RPAR
                    {}
                    | direct_declarator LPAR new_scope RPAR
                    {
                        curTable->name = $1->name;
                        if($1->type->type != SymType::Void) {
                            curTable->lookup("return")->update($1->type);
                        }
                        $1->nestedTable = curTable;
                        $1->category = Sym::FUNCTION;
                        curTable->parent = globalTable;
                        changeTable(globalTable);
                        curSym = $$;
                    }
                    ;

new_scope:
                {
                    if(curSym->nestedTable == NULL) {
                        changeTable(new SymTable(""));
                    }
                    else {
                        changeTable(curSym->nestedTable);
                        emit("label", curTable->name);
                    }
                }
	            ;

pointer:
            MULT type_qualifier_list_opt 
            { $$ = new SymType(SymType::Pointer); }
            | MULT type_qualifier_list_opt pointer
            { $$ = new SymType(SymType::Pointer, $3); }
            ;

type_qualifier_list_opt:
                        type_qualifier_list
                        |
                        ;

type_qualifier_list:
                        type_qualifier
                        | type_qualifier_list type_qualifier
                        ;

parameter_type_list:
                        parameter_list
                        | parameter_list COMMA ELLIPSIS
                        ;                       

parameter_list:
                parameter_declaration
                | parameter_list COMMA parameter_declaration
                ;

parameter_declaration:
                        declaration_specifiers declarator
                        {
                            $2->category = Sym::PARAMETER; 	
                            curTable->parameters.push_back($2->name);
                        }
                        | declaration_specifiers
                        ;

identifier_list:
                    IDENTIFIER
                    | identifier_list COMMA IDENTIFIER
                    ;

type_name:
            specifier_qualifier_list
            ;

initializer:
                assignment_expression
                { $$ = $1->sym; }
                | LCUR initializer_list RCUR
                {}
                | LCUR initializer_list COMMA RCUR
                {}
                ;

initializer_list:
                    designation_opt initializer
                    | initializer_list COMMA designation_opt initializer
                    ;

designation_opt:
                    designation
                    |
                    ;

designation:
                designator_list ASSIGN
                ;

designator_list:
                    designator
                    | designator_list designator
                    ;

designator:
            LSQ constant_expression RSQ
            | DOT IDENTIFIER
            ;

//Statements
statement:
            labeled_statement
            | compound_statement
            { $$ = $1; }
            | expression_statement
            {
                $$ = new Statement();
                $$->nextList = $1->nextList;
            }
            | selection_statement
            { $$ = $1; }
            | iteration_statement
            { $$ = $1; }
            | jump_statement
            { $$ = $1; }
            ;

labeled_statement:
                    IDENTIFIER COLON statement
                    {}
                    | CASE constant_expression COLON statement
                    {}
                    | DEFAULT COLON statement
                    {}
                    ;

compound_statement:
                    LCUR block_item_list_opt RCUR
                    { $$ = $2;}
                    ;

block_item_list:
                    block_item
                    { $$ = $1; }
                    | block_item_list M block_item
                    {
                        $$ = $3;
                        backpatch($1->nextList,$2);
                    }
                    ;

block_item_list_opt:
                        block_item_list
                        { $$ = $1; }
                        |
                        { $$ = new Statement(); }
                        ;

block_item:
            declaration
            { $$ = new Statement(); }
            | statement
            { $$ = $1; }
            ;

expression_statement:
                        expression_opt SEMICOLON
                        { $$ = $1; }
                        ;

selection_statement:
                    IF LPAR expression RPAR M statement N %prec THEN
                    {
                        $$ = new Statement();
                        $3->toBool();
                        backpatch($3->trueList, $5);
                        $$->nextList = merge($3->falseList, merge($6->nextList, $7->nextList));
                    }
                    | IF LPAR expression RPAR M statement N ELSE M statement
                    {
                        $$ = new Statement();
                        $3->toBool();
                        backpatch($3->trueList, $5);
                        backpatch($3->falseList, $9);
                        $$->nextList = merge($10->nextList, merge($6->nextList, $7->nextList));
                    }
                    | SWITCH LPAR expression RPAR statement
                    {}
                    ;

iteration_statement:
                    WHILE M LPAR expression RPAR M statement
                    {
                        $$ = new Statement();
                        $4->toBool();
                        backpatch($7->nextList, $2);
                        backpatch($4->trueList, $6);
                        $$->nextList = $4->falseList;
                        emit("goto", toString($2));
                    }
                    | DO M statement M WHILE LPAR expression RPAR SEMICOLON
                    {
                        $$ = new Statement();
                        $7->toBool();
                        backpatch($7->trueList, $2);
                        backpatch($3->nextList, $4);
                        $$->nextList = $7->falseList;
                    }
                    | FOR LPAR expression_opt SEMICOLON M expression_opt SEMICOLON M expression_opt N RPAR M statement
                    {
                        $$ = new Statement();
                        $6->toBool();
                        backpatch($6->trueList, $12);
                        backpatch($10->nextList, $5);
                        backpatch($13->nextList, $8);
                        emit("goto", toString($8));
                        $$->nextList = $6->falseList;
                    }
                    | FOR LPAR declaration expression_opt SEMICOLON expression_opt RPAR statement
                    {}
                    ;

expression_opt:
                expression
                { $$ = $1; }
                |
                { $$ = new Expression(); }
                ;

jump_statement:
                GOTO IDENTIFIER SEMICOLON
                {}
                | CONTINUE SEMICOLON
                {}
                | BREAK SEMICOLON
                {}
                | RETURN expression_opt SEMICOLON
                {
                    $$ = new Statement();
                    if($2->sym != NULL) {
                        emit("return", $2->sym->name);
                    } else {
                        emit("return", "");
                    }
                }
                ;

//External Definitions
translation_unit:
                    external_declaration
                    | translation_unit external_declaration
                    ;

external_declaration:
                        function_definition
                        | declaration
                        ;

function_definition:
                    declaration_specifiers declarator declaration_list_opt new_scope LCUR block_item_list_opt RCUR
                    {
                        tableCnt = 0;
                        emit("labelend", $2->name);	
                        if($2->type->type != SymType::Void) {
                            curTable->lookup("return")->update($2->type);	
                        }
                        changeTable(globalTable);
                    }
                    ;

declaration_list_opt:
                        declaration_list
                        |
                        ;

declaration_list:
                    declaration
                    | declaration_list declaration
                    ;
%%

void yyerror(char* s)
{
    printf("Error Detected : %s\n", s);
}