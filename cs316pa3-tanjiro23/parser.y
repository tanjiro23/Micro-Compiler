%{
    void yyerror(char const *s);
    extern char* yytext;
    extern "C" int yylex();
    #include "symboltable.cpp"
    ST_stack ST;
%}

%token PROGRAM
%token _BEGIN
%token VOID
%token IDENTIFIER
%token INT
%token FLOAT
%token FLOATLITERAL
%token INTLITERAL
%token STRINGLITERAL
%token STRING
%token READ
%token WRITE
%token FUNCTION
%token RETURN
%token IF
%token ELSE
%token FI
%token FOR
%token ROF
%token END
%token CONTINUE
%token BREAK

%code requires {
    #include<iostream>
    #include<string>
    #include<vector>
    #include<utility>
}

%union {
    int intval;
    float floatval;
    std::string* strval;
    std::vector<std::string*>* strlist;
}

%type <strval> str id IDENTIFIER STRINGLITERAL
%type <strlist> id_list id_tail
%type <intval> var_type INT any_type VOID
%type <floatval> FLOAT

%%

/* Program */
program : PROGRAM id _BEGIN {ST.addTable("GLOBAL");} pgm_body END {ST.pop_table();};
id : IDENTIFIER;
pgm_body : decl func_declarations;
decl : string_decl decl | var_decl decl |
;

/* Global String Declaration */
string_decl : STRING id ':''=' str ';' 
            { ST.addDecl(*($2), "STRING", *($5)); }
; 
str : STRINGLITERAL;

/* Variable Declaration */
var_decl : var_type id_list ';'
{
    std::vector<std::string*> list = *($2);
    for (int i = (int)list.size() - 1; i >= 0; i--) {
        if ($1 == INT) {
            ST.addDecl(*list[i], "INT");
        }
        else {
            ST.addDecl(*list[i], "FLOAT");
        }
    }
}
;
var_type : FLOAT {$$ = FLOAT;} | INT {$$ = INT;};
any_type : var_type {$$ = $1;} | VOID {$$ = $1;};
id_list : id id_tail {$$ = $2; $$->push_back($1);};
id_tail : ',' id id_tail {$$ = $3; $$->push_back($2);} | {std::vector<std::string*>* tmp = new std::vector<std::string*>; $$ = tmp;}
;

/* Function Parameter List */
param_decl_list : param_decl param_decl_tail |
;
param_decl : var_type id {ST.addDecl(*($2), ($1 == INT) ? "INT" : "FLOAT", 1);};
param_decl_tail : ',' param_decl param_decl_tail |
;

/* Function Declarations */
func_declarations : func_decl func_declarations |
;
func_decl : FUNCTION any_type id {ST.addTable(*($3));} '(' param_decl_list ')' _BEGIN func_body END {ST.pop_table();};
func_body : decl stmt_list;

/* Statment List */
stmt_list : stmt stmt_list |
;
stmt : base_stmt | if_stmt | for_stmt;
base_stmt : assign_stmt | read_stmt | write_stmt | return_stmt;

/* Basic Statements */
assign_stmt : assign_expr ';';
assign_expr : id ':''=' expr;
read_stmt : READ '(' id_list ')'';';
write_stmt : WRITE '(' id_list ')'';';
return_stmt : RETURN expr ';';

/* Expressions */
expr : expr_prefix factor;
expr_prefix : expr_prefix factor addop |
;
factor : factor_prefix postfix_expr;
factor_prefix : factor_prefix postfix_expr mulop |
;
postfix_expr : primary | call_expr;
call_expr : id '(' expr_list ')';
expr_list : expr expr_list_tail |
;
expr_list_tail : ',' expr expr_list_tail |
;
primary : '(' expr ')' | id | INTLITERAL | FLOATLITERAL;
addop : '+' | '-';
mulop : '*' | '/';

/* Complex Statements and Condition */
if_stmt : IF {ST.addTable();} '(' cond ')' decl stmt_list {ST.pop_table();} else_part FI;
else_part : ELSE {ST.addTable();} decl stmt_list {ST.pop_table();} |
;
cond : expr compop expr;
compop : '<' | '>' | '=' | '!''=' | '<''=' | '>''=';

init_stmt : assign_expr |
;
incr_stmt : assign_expr |
;

for_stmt : FOR {ST.addTable();} '(' init_stmt ';' cond ';' incr_stmt ')' decl aug_stmt_list ROF {ST.pop_table();};

aug_stmt_list : aug_stmt aug_stmt_list |
;
aug_stmt : base_stmt | aug_if_stmt | for_stmt | CONTINUE ';' | BREAK ';';

aug_if_stmt : IF {ST.addTable();} '(' cond ')' decl aug_stmt_list {ST.pop_table();} aug_else_part FI;
aug_else_part : ELSE {ST.addTable();} decl aug_stmt_list {ST.pop_table();} |
;

%%

void yyerror(char const* s){
    exit(1);
}

int main() {
    yyparse();
    ST.printStack();
    return 0;
}