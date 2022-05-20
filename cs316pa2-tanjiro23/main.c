#include <stdio.h>
#include "parser.h"

extern FILE *yyin;
int yylex();
int yyparse();

void yyerror(const char *s)
{
    printf("Not accepted\n");
}

int main(int argc, char **argv)
{
    FILE *fp = fopen(argv[1], "r");
    if (fp)
        yyin = fp;

    if (yyparse() == 0)
        printf("Accepted\n");
}