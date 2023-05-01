#include <stdio.h>

extern int yyparse();

int main() 
{
    printf("############################## PARSING START ##############################\n");
    printf("\nPARSING LINE NO. 1 :\n\n");
    yyparse();
    printf("\n############################### PARSING END ###############################");
    return 0;
}