#include "parser.c"
#include <iostream>

using namespace std;

void yyerror(char const *s)
{
    cout << "GRAMMAR FAILED, check parser or scanner";
    exit(1);
}

int main()
{
    yyparse();
    for (symbol_table *table : WC->symbolTable->STvector)
    {
        if (table->scope != "GLOBAL")
        {
            continue;
        }
        for (auto i : table->symbolTable)
        {
            if (i.second.type == "STRING")
                cout << "str " << i.first << " " << i.second.value << endl;
            else
                cout << "var " << i.first << endl;
        }
    }
    cout << "push\n";
    cout << "push r0\n";
    cout << "push r1\n";
    cout << "push r2\n";
    cout << "push r3\n";
    cout << "jsr main\n";
    cout << "sys halt\n";
    assemblyCode assmCode(WC, WC->symbolTable->STvector);
    assmCode.print();
    cout << "end\n";
    return 0;
}

/* I have taken inspiration from Rupesh Kalantre's code, Link: https://github.com/Rupesh282/tiny_compiler/tree/cs316pa4 */