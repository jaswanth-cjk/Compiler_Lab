%{
    #include <stdio.h>
    #define KEYWORD 101
    #define IDENTIFIER 102
    #define INT_CONST 103
    #define FLOAT_CONST 104
    #define CHAR_CONST 105
    #define STRING_LITERAL 106
    #define PUNCTUATOR 107
    #define MULTI_COMMENT 108
    #define SINGLE_COMMENT 109
    #define MULTI_COMMENT_START 110
    #define MULTI_COMMENT_END 111
    #define SINGLE_COMMENT_START 112
    #define SINGLE_COMMENT_END 113
    #define INVALID_TOKEN 114
%}

%x  M_COMMENT
%x  S_COMMENT
KEYWORD                     "auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"inline"|"int"|"long"|"register"|"restrict"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"|"_Bool"|"_Complex"|"_Imaginary"
PUNCTUATOR                  "["|"]"|"("|")"|"{"|"}"|"."|"->"|"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"|"?"|":"|";"|"..."|"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="|","|"#"
ESCAPE_SEQUENCE             "\\\'"|"\\\""|"\?"|"\\"|"\a"|"\b"|"\f"|"\n"|"\r"|"\t"|"\v"
IDENTIFIER                  [a-zA-Z_][a-zA-Z0-9_]*
S_CHAR                      [^\"\n\\]|{ESCAPE_SEQUENCE}
S_CHAR_SEQUENCE             {S_CHAR}+
STRING_LITERAL              \"({S_CHAR_SEQUENCE})?\"
INT_CONST                   [1-9][0-9]*|[0]+
C_CHAR                      [^\'\n\\]|{ESCAPE_SEQUENCE}
C_CHAR_SEQUENCE             ({C_CHAR})+
CHAR_CONST                  \'({C_CHAR_SEQUENCE})\'
DIGIT_SEQUENCE              [0-9]+
EXPONENT_PART               ([Ee]([+-]?)({DIGIT_SEQUENCE}))
FRAC_CONST                  {DIGIT_SEQUENCE}?\.{DIGIT_SEQUENCE}|{DIGIT_SEQUENCE}\.
FLOAT_CONST                 ({FRAC_CONST}{EXPONENT_PART}?)|({DIGIT_SEQUENCE}{EXPONENT_PART})
CONST                       {INT_CONST}%{
    #include <stdio.h>
    #define KEYWORD 101
    #define IDENTIFIER 102
    #define INT_CONST 103
    #define FLOAT_CONST 104
    #define CHAR_CONST 105
    #define STRING_LITERAL 106
    #define PUNCTUATOR 107
    #define MULTI_COMMENT 108
    #define SINGLE_COMMENT 109
    #define MULTI_COMMENT_START 110
    #define MULTI_COMMENT_END 111
    #define SINGLE_COMMENT_START 112
    #define SINGLE_COMMENT_END 113
    #define INVALID_TOKEN 114
%}

%x  M_COMMENT
%x  S_COMMENT
KEYWORD                     "auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"inline"|"int"|"long"|"register"|"restrict"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"|"_Bool"|"_Complex"|"_Imaginary"
PUNCTUATOR                  "["|"]"|"("|")"|"{"|"}"|"."|"->"|"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"|"?"|":"|";"|"..."|"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="|","|"#"
ESCAPE_SEQUENCE             "\\\'"|"\\\""|"\?"|"\\"|"\a"|"\b"|"\f"|"\n"|"\r"|"\t"|"\v"
IDENTIFIER                  [a-zA-Z_][a-zA-Z0-9_]*
S_CHAR                      [^\"\n\\]|{ESCAPE_SEQUENCE}
S_CHAR_SEQUENCE             {S_CHAR}+
STRING_LITERAL              \"({S_CHAR_SEQUENCE})?\"
INT_CONST                   [1-9][0-9]*|[0]+
C_CHAR                      [^\'\n\\]|{ESCAPE_SEQUENCE}
C_CHAR_SEQUENCE             ({C_CHAR})+
CHAR_CONST                  \'({C_CHAR_SEQUENCE})\'
DIGIT_SEQUENCE              [0-9]+
EXPONENT_PART               ([Ee]([+-]?)({DIGIT_SEQUENCE}))
FRAC_CONST                  {DIGIT_SEQUENCE}?\.{DIGIT_SEQUENCE}|{DIGIT_SEQUENCE}\.
FLOAT_CONST                 ({FRAC_CONST}{EXPONENT_PART}?)|({DIGIT_SEQUENCE}{EXPONENT_PART})
CONST                       {INT_CONST}|{FLOAT_CONST}|{CHAR_CONST}
WS                          [ \n\t]

%%

{KEYWORD}                   { return KEYWORD;}
{IDENTIFIER}                { return IDENTIFIER;}
{INT_CONST}                 { return INT_CONST;}
{FLOAT_CONST}               { return FLOAT_CONST;}
{CHAR_CONST}                { return CHAR_CONST;}
{STRING_LITERAL}            { return STRING_LITERAL;}
{PUNCTUATOR}                { return PUNCTUATOR;}
{ESCAPE_SEQUENCE}           {}
{WS}                        {}

"/*"                        { BEGIN(M_COMMENT); return MULTI_COMMENT_START;}
<M_COMMENT>"*/"             { BEGIN(INITIAL); return MULTI_COMMENT_END;}
<M_COMMENT>.                { return MULTI_COMMENT;}
<M_COMMENT>"\n"             { return MULTI_COMMENT;}

"//"                        { BEGIN(S_COMMENT); return SINGLE_COMMENT_START;}
<S_COMMENT>"\n"             { BEGIN(INITIAL); return SINGLE_COMMENT_END;}
<S_COMMENT>.                { return SINGLE_COMMENT;}

.                           { return INVALID_TOKEN;}

%%

int yywrap()
{
    return 1;
}