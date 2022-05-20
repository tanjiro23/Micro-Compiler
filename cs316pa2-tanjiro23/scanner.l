%{
	#include "parser.h"
%}

DIGIT [0-9]
IDENTIFIER [_a-zA-Z][_a-zA-Z0-9]*
QUOTE ["]
OPERATOR [:]|[+]|[-]|[*]|[/]|[=]|[!]|[<]|[>]|[(]|[)]|[,]|[;]
SPACE [\r\n\t ]
COMMENT [-]
NOT [^\n]
NEWLINE [\n]

%%

{COMMENT}{COMMENT}({NOT})*{NEWLINE} {}
{SPACE}+ {}
BREAK {return BREAK;}
CONTINUE {return CONTINUE;}
BEGIN  {return _BEGIN;}
PROGRAM  {return PROGRAM;}
END  {return END;}
FUNCTION  {return FUNCTION;}
READ  {return READ;}
WRITE  {return WRITE;}
IF  {return IF;}
ELSE  {return ELSE;}
FI  {return FI;}
FOR  {return FOR;}
ROF  {return ROF;}
RETURN  {return RETURN;}
INT  {return INT;}
VOID  {return VOID;}
STRING  {return STRING;}
FLOAT  {return FLOAT;}
{DIGIT}+ {return INTLITERAL;}
{DIGIT}*"."{DIGIT}+ {return FLOATLITERAL;}
{QUOTE}[^"]+{QUOTE} {return STRINGLITERAL;}
{IDENTIFIER} {return IDENTIFIER;}
{OPERATOR} {return *yytext;}

%%

int yywrap()
{
  	return 1;
}