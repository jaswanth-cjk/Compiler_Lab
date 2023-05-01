%{
    extern int yylex();
    void yyerror(char* s);
%}

%union {
    int intval;
    float floatval;
    char charval;
    char* stringval;
}

%token AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE
%token ELSE ENUM EXTERN FLOAT FOR GOTO IF INLINE INT LONG
%token REGISTER RESTRICT RETURN SHORT SIGNED SIZEOF STATIC STRUCT SWITCH
%token TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE BOOL COMPLEX IMAGINARY 

%token <stringval> IDENTIFIER
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
%%

//Expressions
primary_expression:
                    IDENTIFIER
                    { printf("primary_expression -> identifier\n"); }
                    | constant
                    { printf("primary_expression -> constant\n"); }
                    | STRING_LITERAL
                    { printf("primary_expression -> string-literal\n"); }
                    | LPAR expression RPAR
                    { printf("primary_expression -> ( expression )\n"); }
                    ;

constant:
            INT_CONST
            { printf("constant -> INT_CONST\n"); }
            | FLOAT_CONST
            { printf("constant -> FLOAT_CONST\n"); }
            | CHAR_CONST
            { printf("constant -> CHAR_CONST\n"); }
            ;

postfix_expression:
                    primary_expression
                    { printf("postfix_expression -> primary_expression\n"); }
                    | postfix_expression LSQ expression RSQ
                    { printf("postfix_expression -> postfix_expression [ expression ]\n"); }
                    | postfix_expression LPAR argument_expression_list_opt RPAR
                    { printf("postfix_expression -> postfix_expression ( argument_expression_list_opt )\n"); }
                    | postfix_expression DOT IDENTIFIER
                    { printf("postfix_expression -> postfix_expression . identifier\n"); }
                    | postfix_expression ARROW IDENTIFIER
                    { printf("postfix_expression -> postfix_expression -> identifier\n"); }
                    | postfix_expression INCREMENT
                    { printf("postfix_expression -> postfix_expression ++\n"); }
                    | postfix_expression DECREMENT
                    { printf("postfix_expression -> postfix_expression --\n"); }
                    | LPAR type_name RPAR LCUR initializer_list RCUR
                    { printf("postfix_expression -> ( type_name ) { initializer_list }\n"); }
                    | LPAR type_name RPAR LCUR initializer_list COMMA RCUR     
                    { printf("postfix_expression -> ( type_name ) { initializer_list , }\n"); }
                    ;  

argument_expression_list:
                            assignment_expression
                            { printf("argument_expression_list -> assignment_expression\n"); }
                            | argument_expression_list COMMA assignment_expression   
                            { printf("argument_expression_list -> argument_expression_list , assignment_expression\n"); } 
                            ;

argument_expression_list_opt:
                                argument_expression_list
                                { printf("argument_expression_list_opt -> argument_expression_list\n"); }
                                |
                                {{ printf("argument_expression_list_opt -> EPSILON\n"); }}
                                ;

unary_expression:
                    postfix_expression
                    { printf("unary_expression -> postfix_expression\n"); }
                    | INCREMENT unary_expression
                    { printf("unary_expression -> ++ unary_expression\n"); }
                    | DECREMENT unary_expression
                    { printf("unary_expression -> −− unary_expression\n"); }
                    | unary_operator cast_expression
                    { printf("unary_expression -> unary_operator cast_expression\n"); }
                    | SIZEOF unary_expression
                    { printf("unary_expression -> sizeof unary_expression\n"); }
                    | SIZEOF LPAR type_name RPAR  
                    { printf("unary_expression -> sizeof ( type_name ) \n"); }
                    ;    

unary_operator: 
                BIN_AND 
                { printf("unary_operator -> &\n"); }
                | MULT
                { printf("unary_operator -> *\n"); }
                | PLUS 
                { printf("unary_operator -> +\n"); }
                | MINUS
                { printf("unary_operator -> -\n"); }
                | TILDE
                { printf("unary_operator -> ~\n"); }
                | NOT
                { printf("unary_operator -> !\n"); }
                ;

cast_expression:
                    unary_expression
                    { printf("cast_expression -> unary_expression\n"); }
                    | LPAR type_name RPAR cast_expression
                    { printf("cast_expression -> ( type_name ) cast_expression\n"); }
                    ;

multiplicative_expression:
                            cast_expression
                            { printf("multiplicative_expression -> cast_expression\n"); }
                            | multiplicative_expression MULT cast_expression
                            { printf("multiplicative_expression -> multiplicative_expression * cast_expression\n"); }
                            | multiplicative_expression SLASH cast_expression
                            { printf("multiplicative_expression -> multiplicative_expression / cast_expression\n"); }
                            | multiplicative_expression MOD cast_expression     
                            { printf("multiplicative_expression -> multiplicative_expression modulo cast_expression\n"); }
                            ;

additive_expression:        
                        multiplicative_expression
                        { printf("additive_expression -> multiplicative_expression\n"); }
                        | additive_expression PLUS multiplicative_expression
                        { printf("additive_expression -> additive_expression + multiplicative_expression\n"); }
                        | additive_expression MINUS multiplicative_expression
                        { printf("additive_expression -> additive_expression − multiplicative_expression\n"); }
                        ;

shift_expression:
                    additive_expression
                    { printf("shift_expression -> additive_expression\n"); }
                    | shift_expression LSHIFT additive_expression
                    { printf("shift_expression -> shift_expression << additive_expression\n"); }
                    | shift_expression RSHIFT additive_expression
                    { printf("shift_expression -> shift_expression >> additive_expression\n"); }
                    ;

relational_expression:
                        shift_expression
                        { printf("relational_expression -> shift_expression\n"); }
                        | relational_expression LT shift_expression
                        { printf("relational_expression -> relational_expression < shift_expression\n"); }
                        | relational_expression GT shift_expression
                        { printf("relational_expression -> relational_expression > shift_expression\n"); }
                        | relational_expression LEQ shift_expression
                        { printf("relational_expression -> relational_expression <= shift_expression\n"); }
                        | relational_expression GEQ shift_expression
                        { printf("relational_expression -> relational_expression >= shift_expression\n"); }
                        ;

equality_expression:
                        relational_expression
                        { printf("equality_expression -> relational_expression\n"); }
                        | equality_expression EQ relational_expression
                        { printf("equality_expression -> equality_expression == relational_expression\n"); }
                        | equality_expression NEQ relational_expression
                        { printf("equality_expression -> equality_expression ! = relational_expression\n"); }
                        ;

AND_expression:
                equality_expression
                { printf("AND_expression -> equality_expression\n"); }
                | AND_expression BIN_AND equality_expression
                { printf("AND_expression -> AND_expression & equality_expression\n");}
                ;

exclusive_OR_expression:
                            AND_expression
                            { printf("exclusive_OR_expression -> AND_expression\n"); }
                            | exclusive_OR_expression BIN_XOR AND_expression
                            { printf("exclusive_OR_expression -> exclusive_OR_expression ˆ AND_expression\n"); }
                            ;

inclusive_OR_expression:
                            exclusive_OR_expression
                            { printf("inclusive_OR_expression -> exclusive_OR_expression\n"); }
                            | inclusive_OR_expression BIN_OR exclusive_OR_expression
                            { printf("inclusive_OR_expression -> inclusive_OR_expression | exclusive_OR_expression\n"); }
                            ;

logical_AND_expression:
                        inclusive_OR_expression
                        { printf("logical_AND_expression -> inclusive_OR_expression\n"); }
                        | logical_AND_expression AND inclusive_OR_expression
                        { printf("logical_AND_expression -> logical_AND_expression && inclusive_OR_expression\n"); }
                        ;

logical_OR_expression:
                        logical_AND_expression
                        { printf("logical_OR_expression -> logical_AND_expression\n"); }
                        | logical_OR_expression OR logical_AND_expression
                        { printf("logical_OR_expression -> logical_OR_expression || logical_AND_expression\n"); }
                        ;

conditional_expression:
                        logical_OR_expression
                        { printf("conditional_expression -> logical_OR_expression\n"); }
                        | logical_OR_expression QMARK expression COLON conditional_expression
                        { printf("conditional_expression -> logical_OR_expression ? expression : conditional_expression\n"); }
                        ;

assignment_expression:
                        conditional_expression
                        { printf("assignment_expression -> conditional_expression\n"); }
                        | unary_expression assignment_operator assignment_expression
                        { printf("assignment_expression -> unary_expression assignment_operator assignment_expression\n"); }
                        ;

assignment_operator: 
                        ASSIGN
                        { printf("assignment_operator -> =\n"); }
                        | MULT_ASSIGN
                        { printf("assignment_operator -> *=\n"); }
                        | DIV_ASSIGN
                        { printf("assignment_operator -> /=\n"); }
                        | MOD_ASSIGN
                        { printf("assignment_operator -> modulo =\n"); }
                        | ADD_ASSIGN
                        { printf("assignment_operator -> +=\n"); }
                        | SUB_ASSIGN
                        { printf("assignment_operator -> -=\n"); }
                        | LSHIFT_ASSIGN
                        { printf("assignment_operator -> <<=\n"); }
                        | RSHIFT_ASSIGN
                        { printf("assignment_operator -> >>=\n"); }
                        | BIN_AND_ASSIGN
                        { printf("assignment_operator -> &=\n"); }
                        | BIN_XOR_ASSIGN
                        { printf("assignment_operator -> ^=\n"); }
                        | BIN_OR_ASSIGN
                        { printf("assignment_operator -> |=\n"); }
                        ;

expression:
            assignment_expression
            { printf("expression -> assignment_expression\n"); }
            | expression COMMA assignment_expression
            { printf("expression -> expression , assignment_expression\n"); }
            ;

constant_expression:
                        conditional_expression
                        { printf("constant_expression -> conditional_expression\n"); }
                        ;

//Declarations
declaration:
                declaration_specifiers init_declarator_list_opt SEMICOLON
                { printf("declaration -> declaration_specifiers init_declarator_list_opt ;\n"); }
                ;

init_declarator_list_opt:
                            init_declarator_list
                            { printf("init_declarator_list_opt -> init_declarator_list\n"); }
                            |
                            { printf("init_declarator_list_opt -> EPSILON\n"); }
                            ;

declaration_specifiers:
                        storage_class_specifier declaration_specifiers_opt
                        { printf("declaration_specifiers -> storage_class_specifier declaration_specifiers_opt\n"); }
                        | type_specifier declaration_specifiers_opt
                        { printf("declaration_specifiers -> type_specifier declaration_specifiers_opt\n"); }
                        | type_qualifier declaration_specifiers_opt
                        { printf("declaration_specifiers -> type_qualifier declaration_specifiers_opt\n"); }
                        | function_specifier declaration_specifiers_opt
                        { printf("declaration_specifiers -> function_specifier declaration_specifiers_opt\n"); }
                        ;

declaration_specifiers_opt:
                            declaration_specifiers
                            { printf("declaration_specifiers_opt -> declaration_specifiers\n"); }
                            |
                            { printf("declaration_specifiers_opt -> EPSILON\n"); }
                            ;

init_declarator_list:
                        init_declarator
                        { printf("init_declarator_list -> init_declarator\n"); }
                        | init_declarator_list COMMA init_declarator
                        { printf("init_declarator_list -> init_declarator_list , init_declarator\n"); }
                        ;

init_declarator:
                    declarator
                    { printf("init_declarator -> declarator\n"); }
                    | declarator ASSIGN initializer
                    { printf("init_declarator -> declarator = initializer\n"); }
                    ;

storage_class_specifier:
                            EXTERN
                            { printf("storage_class_specifier -> extern\n"); }
                            | STATIC
                            { printf("storage_class_specifier -> static\n"); }
                            | AUTO
                            { printf("storage_class_specifier -> auto\n"); }
                            | REGISTER
                            { printf("storage_class_specifier -> register\n"); }
                            ;

type_specifier:
                VOID
                { printf("type_specifier -> void\n"); }
                | CHAR
                { printf("type_specifier -> char\n"); }
                | SHORT
                { printf("type_specifier -> short\n"); }
                | INT
                { printf("type_specifier -> int\n"); }
                | LONG
                { printf("type_specifier -> long\n"); }
                | FLOAT
                { printf("type_specifier -> float\n"); }
                | DOUBLE
                { printf("type_specifier -> double\n"); }
                | SIGNED
                { printf("type_specifier -> signed\n"); }
                | UNSIGNED
                { printf("type_specifier -> unsigned\n"); }
                | BOOL
                { printf("type_specifier -> _Bool\n"); }
                | COMPLEX
                { printf("type_specifier -> _Complex\n"); }
                | IMAGINARY
                { printf("type_specifier -> _Imaginary\n"); }
                | enum_specifier
                { printf("type_specifier -> enum_specifier\n"); }
                ;

specifier_qualifier_list:
                            type_specifier specifier_qualifier_list_opt
                            { printf("specifier_qualifier_list -> type_specifier specifier_qualifier_list_opt\n"); }
                            | type_qualifier specifier_qualifier_list_opt
                            { printf("specifier_qualifier_list -> type_qualifier specifier_qualifier_list_opt\n"); }
                            ;

specifier_qualifier_list_opt:
                                specifier_qualifier_list
                                { printf("specifier_qualifier_list_opt -> specifier_qualifier_list\n"); }
                                |
                                { printf("specifier_qualifier_list_opt -> EPSILON\n"); }
                                ;

enum_specifier:
                ENUM identifier_opt LCUR enumerator_list RCUR
                { printf("enum_specifier -> enum identifier_opt { enumerator_list }\n"); }
                | ENUM identifier_opt LCUR enumerator_list COMMA RCUR
                { printf("enum_specifier -> enum identifier_opt { enumerator_list , }\n"); }
                | ENUM IDENTIFIER
                { printf("enum_specifier -> enum identifier\n"); }
                ;

identifier_opt:
                IDENTIFIER
                { printf("identifier_opt -> IDENTIFIER\n"); }
                |
                { printf("identifier_opt -> EPSILON\n"); }
                ;

enumerator_list:
                enumerator
                { printf("enumerator_list -> enumerator\n"); }
                | enumerator_list COMMA enumerator
                { printf("enumerator_list -> enumerator_list , enumerator\n"); }
                ;

enumerator:
            IDENTIFIER
            { printf("enumerator -> enumeration_constant\n"); }
            | IDENTIFIER ASSIGN constant_expression
            { printf("enumerator -> enumeration_constant = constant_expression\n"); }
            ;

type_qualifier:
                CONST
                { printf("type_qualifier -> const\n"); }
                | RESTRICT
                { printf("type_qualifier -> restrict\n"); }
                | VOLATILE
                { printf("type_qualifier -> volatile\n"); }
                ;

function_specifier:
                    INLINE
                    { printf("function_specifier -> inline\n"); }
                    ;

declarator:
            pointer_opt direct_declarator
            { printf("declarator -> pointer_opt direct_declarator\n"); }
            ;

pointer_opt:
                pointer
                { printf("pointer_opt -> pointer\n"); }
                |
                { printf("pointer_opt -> EPSILON\n"); }
                ;

direct_declarator:
                    IDENTIFIER
                    { printf("direct_declarator -> identifier\n"); }
                    | LPAR declarator RPAR
                    { printf("direct_declarator -> ( declarator )\n"); }
                    | direct_declarator LSQ type_qualifier_list_opt assignment_expression_opt RSQ
                    { printf("direct_declarator -> direct_declarator [ type_qualifier_list_opt assignment_expression_opt ]\n"); }
                    | direct_declarator LSQ STATIC type_qualifier_list_opt assignment_expression RSQ
                    { printf("direct_declarator -> direct_declarator [ static type_qualifier_list_opt assignment_expression ]\n"); }
                    | direct_declarator LSQ type_qualifier_list STATIC assignment_expression RSQ
                    { printf("direct_declarator -> direct_declarator [ type_qualifier_list static assignment_expression ]\n"); }
                    | direct_declarator LSQ type_qualifier_list_opt MULT RSQ
                    { printf("direct_declarator -> direct_declarator [ type_qualifier_list_opt * ]\n"); }
                    | direct_declarator LPAR parameter_type_list RPAR
                    { printf("direct_declarator -> direct_declarator ( parameter_type_list )\n"); }
                    | direct_declarator LPAR identifier_list_opt RPAR
                    { printf("direct_declarator -> direct_declarator ( identifier_list_opt )\n"); }
                    ;

type_qualifier_list_opt:
                            type_qualifier_list
                            { printf("type_qualifier_list_opt -> type_qualifier_list\n"); }
                            |
                            { printf("type_qualifier_list_opt -> EPSILON\n"); }
                            ;

assignment_expression_opt:
                            assignment_expression
                            { printf("assignment_expression_opt -> assignment_expression\n"); }
                            |
                            { printf("assignment_expression_opt -> EPSILON\n"); }
                            ;

identifier_list_opt:
                        identifier_list
                        { printf("identifier_list_opt -> identifier_list\n"); }
                        |
                        { printf("identifier_list_opt -> EPSILON\n"); }
                        ;

pointer:
            MULT type_qualifier_list_opt 
            { printf("pointer -> * type_qualifier_list_opt\n"); }
            | MULT type_qualifier_list_opt pointer
            { printf("pointer -> * type_qualifier_list_opt pointer\n"); }
            ;

type_qualifier_list:
                        type_qualifier
                        { printf("type_qualifier_list -> type_qualifier\n"); }
                        | type_qualifier_list type_qualifier
                        { printf("type_qualifier_list -> type_qualifier_list type_qualifier\n"); }
                        ;

parameter_type_list:
                        parameter_list
                        { printf("parameter_type_list -> parameter_list\n"); }
                        | parameter_list COMMA ELLIPSIS
                        { printf("parameter_type_list -> parameter_list , ...\n"); }
                        ;                       

parameter_list:
                parameter_declaration
                { printf("parameter_list -> parameter_declaration\n"); }
                | parameter_list COMMA parameter_declaration
                { printf("parameter_list -> parameter_list , parameter_declaration\n"); }
                ;

parameter_declaration:
                        declaration_specifiers declarator
                        { printf("parameter_declaration -> declaration_specifiers declarator\n"); }
                        | declaration_specifiers
                        { printf("parameter_declaration -> declaration_specifiers\n"); }
                        ;

identifier_list:
                    IDENTIFIER
                    { printf("identifier_list -> identifier\n"); }
                    | identifier_list COMMA IDENTIFIER
                    { printf("identifier_list -> identifier_list , identifier\n"); }
                    ;

type_name:
            specifier_qualifier_list
            { printf("type_name -> specifier_qualifier_list\n"); }
            ;

initializer:
                assignment_expression
                { printf("initializer -> assignment_expression\n"); }
                | LCUR initializer_list RCUR
                { printf("initializer -> { initializer_list }\n"); }
                | LCUR initializer_list COMMA RCUR
                { printf("initializer -> { initializer_list , }\n"); }
                ;

initializer_list:
                    designation_opt initializer
                    { printf("initializer_list -> designation_opt initializer\n"); }
                    | initializer_list COMMA designation_opt initializer
                    { printf("initializer_list -> initializer_list , designation_opt initializer\n"); }
                    ;

designation_opt:
                    designation
                    { printf("designation_opt -> designation\n"); }
                    |
                    { printf("designation_opt -> EPSILON\n"); }
                    ;

designation:
                designator_list ASSIGN
                { printf("designation -> designator_list =\n"); }
                ;

designator_list:
                    designator
                    { printf("designator_list -> designator\n"); }
                    | designator_list designator
                    { printf("designator_list -> designator_list designator\n"); }
                    ;

designator:
            LSQ constant_expression RSQ
            { printf("designator -> [ constant_expression ]\n"); }
            | DOT IDENTIFIER
            { printf("designator -> . identifier\n"); }
            ;

//Statements
statement:
            labeled_statement
            { printf("statement -> labeled_statement\n"); }
            | compound_statement
            { printf("statement -> compound_statement\n"); }
            | expression_statement
            { printf("statement -> expression_statement\n"); }
            | selection_statement
            { printf("statement -> selection_statement\n"); }
            | iteration_statement
            { printf("statement -> iteration_statement\n"); }
            | jump_statement
            { printf("statement -> jump_statement\n"); }
            ;

labeled_statement:
                    IDENTIFIER COLON statement
                    { printf("labeled_statement -> identifier : statement\n"); }
                    | CASE constant_expression COLON statement
                    { printf("labeled_statement -> case constant_expression : statement\n"); }
                    | DEFAULT COLON statement
                    { printf("labeled_statement -> default : statement\n"); }
                    ;

compound_statement:
                    LCUR block_item_list_opt RCUR
                    { printf("compound_statement -> { block_item_list_opt }\n"); }
                    ;

block_item_list:
                    block_item
                    { printf("block_item_list -> block_item\n"); }
                    | block_item_list block_item
                    { printf("block_item_list -> block_item_list block_item\n"); }
                    ;

block_item_list_opt:
                        block_item_list
                        { printf("block_item_list_opt -> block_item_list\n"); }
                        |
                        { printf("block_item_list_opt -> EPSILON\n"); }
                        ;

block_item:
            declaration
            { printf("block_item -> declaration\n"); }
            | statement
            { printf("block_item -> statement\n"); }
            ;

expression_statement:
                        expression_opt SEMICOLON
                        { printf("expression_statement-> expression_opt ;\n"); }
                        ;

selection_statement:
                    IF LPAR expression RPAR statement
                    { printf("selection_statement -> if ( expression ) statement\n"); }
                    | IF LPAR expression RPAR statement ELSE statement
                    { printf("selection_statement -> if ( expression ) statement else statement\n"); }
                    | SWITCH LPAR expression RPAR statement
                    { printf("selection_statement -> switch ( expression ) statement\n"); }
                    ;

iteration_statement:
                    WHILE LPAR expression RPAR statement
                    { printf("iteration_statement -> while ( expression ) statement\n"); }
                    | DO statement WHILE LPAR expression RPAR SEMICOLON
                    { printf("iteration_statement -> do statement while ( expression ) ;\n"); }
                    | FOR LPAR expression_opt SEMICOLON expression_opt SEMICOLON expression_opt RPAR statement
                    { printf("iteration_statement -> for ( expression_opt ; expression_opt ; expression_opt ) statement\n"); }
                    | FOR LPAR declaration expression_opt SEMICOLON expression_opt RPAR statement
                    { printf("iteration_statement -> for ( declaration expression_opt ; expression_opt ) statement\n"); }
                    ;

expression_opt:
                expression
                { printf("expression_opt -> expression\n"); }
                |
                { printf("expression_opt -> EPSILON\n"); }
                ;

jump_statement:
                GOTO IDENTIFIER SEMICOLON
                { printf("jump_statement -> goto identifier ;\n"); }
                | CONTINUE SEMICOLON
                { printf("jump_statement -> continue ;\n"); }
                | BREAK SEMICOLON
                { printf("jump_statement -> break ;\n"); }
                | RETURN expression_opt SEMICOLON
                { printf("jump_statement -> return expression_opt ;\n"); }
                ;

//External Definitions
translation_unit:
                    external_declaration
                    { printf("translation_unit -> external_declaration\n"); }
                    | translation_unit external_declaration
                    { printf("translation_unit -> external_declaration\n"); }
                    ;

external_declaration:
                        function_definition
                        { printf("external_declaration -> function_definition\n"); }
                        | declaration
                        { printf("external_declaration -> declaration\n"); }
                        ;

function_definition:
                    declaration_specifiers declarator declaration_list_opt compound_statement
                    { printf("function_definition -> declaration_specifiers declarator declaration_list_opt compound_statement\n"); }
                    ;

declaration_list_opt:
                        declaration_list
                        { printf("declaration_list_opt -> declaration_list\n"); }
                        |
                        { printf("declaration_list_opt -> EPSILON\n"); }
                        ;

declaration_list:
                    declaration
                    { printf("declaration_list -> declaration\n"); }
                    | declaration_list declaration
                    { printf("declaration_list -> declaration_list declaration\n"); }
                    ;
%%

void yyerror(char* s)
{
    printf("Error detected : %s\n", s);
}