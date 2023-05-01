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

extern int yylex();
extern char* yytext;

int main()
{
    int token;
    while(token = yylex())
    {
        switch(token) 
        {
            case KEYWORD: printf("<KEYWORD, %d, %s>\n", token, yytext); break;
            case IDENTIFIER: printf("<IDENTIFIER, %d, %s>\n", token, yytext); break;
            case INT_CONST: printf("<INTEGER_CONSTANT, %d, %s>\n", token, yytext); break;
            case FLOAT_CONST: printf("<FLOAT_CONSTANT, %d, %s>\n", token, yytext); break;
            case CHAR_CONST: printf("<CHARACTER_CONSTANT, %d, %s>\n", token, yytext); break;
            case STRING_LITERAL: printf("<STRING_LITERAL, %d, %s>\n", token, yytext); break;
            case PUNCTUATOR: printf("<PUNCTUATOR, %d, %s>\n", token, yytext); break;
            case MULTI_COMMENT_START: printf("<MULTI_LINE_COMMENT_BEGINS, %d, %s>\n", token, yytext); break;
            case MULTI_COMMENT_END: printf("<MULTI_LINE_COMMENT_ENDS, %d, %s>\n", token, yytext); break;
            case MULTI_COMMENT: printf("%s", yytext); break;
            case SINGLE_COMMENT_START: printf("<SINGLE_LINE_COMMENT_BEGINS, %d, %s>\n", token, yytext); break;
            case SINGLE_COMMENT_END: printf("<SINGLE_LINE_COMMENT_ENDS, %d, %s>\n", token, yytext); break;
            case SINGLE_COMMENT: printf("%s", yytext); break;
            case INVALID_TOKEN: printf("<INVALID_TOKEN, %d, %s>\n", token, yytext); break;
            default: break;
        }
    }
    return 0;
}