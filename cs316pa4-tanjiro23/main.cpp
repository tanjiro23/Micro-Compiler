#include "parser.c"
#include <iostream>

using namespace std;

void yyerror(char const *s)
{
    exit(1);
}

int main()
{
    yyparse();
    for (symbol_table *table : WC->symbolTable->STvector)
    {
        for (auto i : table->symbolTable)
        {
            if (i.second.type == "STRING")
                cout << "str " << i.first << " " << i.second.value << "\n";
            else
                cout << "var " << i.first << "\n";
        }
    }
    assemblyCode assmCode(WC);
    assmCode.print();
    cout << "sys halt\n";
    return 0;
}

/* I have taken inspiration from Rupesh Kalantre's code, Link: https://github.com/Rupesh282/tiny_compiler/tree/cs316pa4 */