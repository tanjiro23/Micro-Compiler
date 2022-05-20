D [0-9]
L [a-zA-z]
KEYWORDS PROGRAM|BEGIN|END|FUNCTION|READ|WRITE|IF|ELSE|FI|FOR|ROF|BREAK|CONTINUE|RETURN|INT|VOID|STRING|FLOAT
OPERATORS [:][=]|[+]|[-]|[*]|[/]|[=]|[!][=]|[<]|[>]|[(]|[)]|[;]|[,]|[<][=]|[>][=]
SPACE [\n\t\r ]
QUOTES ["]
COMMENT [-]
NOT [^\n]
NEWLINE [\n]

%%
{COMMENT}{COMMENT}({NOT})*{NEWLINE} {}
{SPACE}+ {}
{KEYWORDS}  {printf("Token Type: KEYWORD\nValue: %s\n", yytext);}
{QUOTES}.+{QUOTES}   {printf("Token Type: STRINGLITERAL\nValue: %s\n", yytext);}
{D}+    {printf("Token Type: INTLITERAL\nValue: %s\n", yytext);}
{D}*"."{D}+   {printf("Token Type: FLOATLITERAL\nValue: %s\n", yytext);}
{L}({L}|{D})*   {printf("Token Type: IDENTIFIER\nValue: %s\n", yytext);}
{OPERATORS}  {printf("Token Type: OPERATOR\nValue: %s\n", yytext);}
%%

int main(int argc, char **argv) {
    yyin = fopen(argv[1], "r");
    yylex();
    return 0;
}

int yywrap() {
    return 1;
}