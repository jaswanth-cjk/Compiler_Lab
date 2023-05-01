%{
    #include "ass6_20CS10021_20CS30051_translator.h"
    #include "y.tab.h"
%}

%option yylineno
%x  M_COMMENT
%x  S_COMMENT

KEYWORD                     "auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"inline"|"int"|"long"|"register"|"restrict"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"|"_Bool"|"_Complex"|"_Imaginary"
PUNCTUATOR                  "["|"]"|"("|")"|"{"|"}"|"."|"->"|"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"|"?"|":"|";"|"..."|"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="|","|"#"
ESCAPE_SEQUENCE             "\\\'"|"\\\""|"\\\?"|"\\\\"|"\\a"|"\\b"|"\\f"|"\\n"|"\\r"|"\\t"|"\\v"|"\\0"
IDENTIFIER                  [a-zA-Z_][a-zA-Z0-9_]*
S_CHAR                      [^\"\n\\]|{ESCAPE_SEQUENCE}
S_CHAR_SEQUENCE             {S_CHAR}+
STRING_LITERAL              \"({S_CHAR_SEQUENCE})?\"
ENUM_CONST                  {IDENTIFIER}
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

"auto"                      { return AUTO;                                                     }
"break"			            { return BREAK;                                                    }
"case"			            { return CASE;                                                     }
"char"			            { return CHAR;                                                     }
"const"                     { return CONST;                                                    }
"continue"		            { return CONTINUE;                                                 }
"default"		            { return DEFAULT;                                                  }
"do"			            { return DO;                                                       }
"double"		            { return DOUBLE;                                                   } 
"else"			            { return ELSE;                                                     }
"enum"                      { return ENUM;                                                     }
"extern"		            { return EXTERN;                                                   }
"float"                     { return FLOAT;                                                    }
"for"			            { return FOR;                                                      }
"goto"			            { return GOTO;                                                     }
"if"			            { return IF;                                                       }
"inline"		            { return INLINE;                                                   }
"int"			            { return INT;                                                      }
"long"			            { return LONG;                                                     }
"register"                  { return REGISTER;                                                 }
"restrict"		            { return RESTRICT;                                                 }
"return"		            { return RETURN;                                                   }
"short"			            { return SHORT;                                                    }
"signed"                    { return SIGNED;                                                   }
"sizeof"		            { return SIZEOF;                                                   }
"static"		            { return STATIC;                                                   }
"struct"		            { return STRUCT;                                                   }
"switch"		            { return SWITCH;                                                   }
"typedef"		            { return TYPEDEF;                                                  }
"union"			            { return UNION;                                                    }
"unsigned"                  { return UNSIGNED;                                                 }
"void"			            { return VOID;                                                     }
"volatile"		            { return VOLATILE;                                                 }
"while"			            { return WHILE;                                                    }
"_Bool"                     { return BOOL;                                                     }
"_Complex"                  { return COMPLEX;                                                  }
"_Imaginary"                { return IMAGINARY;                                                }

{IDENTIFIER}                { yylval.sym = curTable->lookup(yytext);; return IDENTIFIER;       }
{STRING_LITERAL}            { yylval.stringval = strdup(yytext); return STRING_LITERAL;        }
{INT_CONST}                 { yylval.intval = atoi(yytext); return INT_CONST;                  }
{FLOAT_CONST}               { yylval.floatval = strdup(yytext); return FLOAT_CONST;            }
{CHAR_CONST}                { yylval.charval = strdup(yytext); return CHAR_CONST;              }
"\n"                        {                                                                  }
{ESCAPE_SEQUENCE}|" "       {                                                                  } 

"/*"                        { BEGIN(M_COMMENT);                                                 }
<M_COMMENT>"*/"             { BEGIN(INITIAL);                                                   }
<M_COMMENT>.                {                                                                   }
<M_COMMENT>"\n"             {                                                                   }

"//"                        { BEGIN(S_COMMENT);                                                 }
<S_COMMENT>"\n"             { BEGIN(INITIAL);                                                   }
<S_COMMENT>.                {                                                                   }

"["                         { return(LSQ);                                                      }
"]"                         { return(RSQ);                                                      }
"("                         { return(LPAR);                                                     }
")"                         { return(RPAR);                                                     }
"{"                         { return(LCUR);                                                     }
"}"                         { return(RCUR);                                                     }
"."                         { return(DOT);                                                      }
"->"                        { return(ARROW);                                                    } 
"++"                        { return(INCREMENT);                                                }
"--"                        { return(DECREMENT);                                                }
"&"                         { return(BIN_AND);                                                  }
"*"                         { return(MULT);                                                     }
"+"                         { return(PLUS);                                                     }
"-"                         { return(MINUS);                                                    }
"~"                         { return(TILDE);                                                    }
"!"                         { return(NOT);                                                      }
"/"                         { return(SLASH);                                                    }
"%"                         { return(MOD);                                                      }
">>"                        { return(RSHIFT);                                                   }
"<<"                        { return(LSHIFT);                                                   }
"<"                         { return(LT);                                                       }
">"                         { return(GT);                                                       }
"<="                        { return(LEQ);                                                      }
">="                        { return(GEQ);                                                      }
"=="                        { return(EQ);                                                       }
"!="                        { return(NEQ);                                                      } 
"^"                         { return(BIN_XOR);                                                  } 
"|"                         { return(BIN_OR);                                                   }
"||"                        { return(OR);                                                       }
"&&"                        { return(AND);                                                      }
"?"                         { return(QMARK);                                                    }
":"                         { return(COLON);                                                    }
";"                         { return(SEMICOLON);                                                }
"..."                       { return(ELLIPSIS);                                                 }
"="                         { return(ASSIGN);                                                   }
"*="                        { return(MULT_ASSIGN);                                              }
"/="                        { return(DIV_ASSIGN);                                               }
"%="                        { return(MOD_ASSIGN);                                               }
"+="                        { return(ADD_ASSIGN);                                               }
"-="                        { return(SUB_ASSIGN);                                               }
"<<="                       { return(LSHIFT_ASSIGN);                                            }
">>="                       { return(RSHIFT_ASSIGN);                                            }
"&="                        { return(BIN_AND_ASSIGN);                                           }
"^="                        { return(BIN_XOR_ASSIGN);                                           }
"|="                        { return(BIN_OR_ASSIGN);                                            }
","                         { return(COMMA);                                                    }
"#"                         { return(HASH);                                                     }

%%

int yywrap()
{
    return 1;
}