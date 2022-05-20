%{
    void yyerror(char const *s);
    extern char* yytext;
    extern "C" int yylex();
    #include "codeStruct.hpp"
    ST_stack* ST = new ST_stack();
    wholeCode* WC = new wholeCode(ST);
    int for_count = 0;
    using namespace std;
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
    #include "assembly.hpp"
}

%union {
    int intval;
    float floatval;
    string* strval;
    vector<string*>* strlist;
    ASTNode* astnode;
    vector<ASTNode*>* astlist;
}

%type <strval> str id IDENTIFIER STRINGLITERAL
%type <strlist> id_list id_tail
%type <intval> var_type INT any_type VOID INTLITERAL
%type <floatval> FLOAT FLOATLITERAL
%type <astnode> mulop addop primary postfix_expr factor_prefix factor expr_prefix expr compop call_expr for_assign_expr incr_stmt
%type <astlist> expr_list expr_list_tail

%%

/* Program */
program : PROGRAM id _BEGIN {ST->addTable("GLOBAL");} pgm_body END {ST->pop_table();};
id : IDENTIFIER;
pgm_body : decl func_declarations;
decl : string_decl decl | var_decl decl |
;

/* Global String Declaration */
string_decl : STRING id ':''=' str ';' 
            { ST->addDecl(*($2), "STRING", *($5)); }
; 
str : STRINGLITERAL;

/* Variable Declaration */
var_decl : var_type id_list ';'
{
    vector<string*> list = *($2);
    for (int i = (int)list.size() - 1; i >= 0; i--) {
        if ($1 == INT) {
            ST->addDecl(*list[i], "INT");
        }
        else {
            ST->addDecl(*list[i], "FLOAT");
        }
    }
}
;
var_type : FLOAT {$$ = FLOAT;} | INT {$$ = INT;};
any_type : var_type {$$ = $1;} | VOID {$$ = $1;};
id_list : id id_tail {$$ = $2; $$->push_back($1);};
id_tail : ',' id id_tail {$$ = $3; $$->push_back($2);} | {vector<string*>* tmp = new vector<string*>; $$ = tmp;}
;

/* Function Parameter List */
param_decl_list : param_decl param_decl_tail |
;
param_decl : var_type id {ST->addDecl(*($2), ($1 == INT) ? "INT" : "FLOAT", 1);};
param_decl_tail : ',' param_decl param_decl_tail |
;

/* Function Declarations */
func_declarations : func_decl func_declarations |
;
func_decl : FUNCTION any_type id { 
    ST->addTable(*($3)); 
    WC->codelines.push_back(new ERline(WC->symbolTable->STstack.top()->scope, "LABEL", *($3)));
    WC->codelines.push_back(new ERline(WC->symbolTable->STstack.top()->scope, "LINK", ""));
} '(' param_decl_list ')' _BEGIN func_body END {ST->pop_table();};
func_body : decl stmt_list;

/* Statment List */
stmt_list : stmt stmt_list |
;
stmt : base_stmt | if_stmt | for_stmt;
base_stmt : assign_stmt | read_stmt | write_stmt | return_stmt;

/* Basic Statements */
assign_stmt : assign_expr ';';
assign_expr : id ':''=' expr {
    ASTNode* node = new ASTNode_ASSIGN(ST->findEntry(*$1));
    node->right = $4;
    node->getCode(WC);    
};
read_stmt : READ '(' id_list ')'';' {
    vector<string*> ids = *$3;
    for(int i = (int)ids.size() - 1; i >= 0; i--) {
        string type;
        tableEntry* entry = ST->findEntry(*ids[i]);
        type = entry->type;
        WC->ERread(type, *ids[i]);
    }
};
write_stmt : WRITE '(' id_list ')'';'{
    vector<string*> ids = *$3;
    for (int i = (int)ids.size() - 1; i >= 0; i--) {
        string type;
        if (*ids[i] == "newline") {
            type = "STRING";
        }
        else {
            tableEntry* entry = ST->findEntry(*ids[i]);
            type = entry->type;
        }
        WC->ERwrite(type, *ids[i]);
    }
};
return_stmt : RETURN expr ';' {
    string a = ($2)->getCode(WC);
    WC->codelines.push_back(new ERline(WC->symbolTable->STstack.top()->scope, "RET", a));
};

/* Expressions */
expr : expr_prefix factor {
    if ($1 == nullptr) {
        $$ = $2;
    }
    else {
        $1->right = $2;
        $$ = $1;
    }
};
expr_prefix : expr_prefix factor addop {
    if ($1 == nullptr) {
        $3->left = $2;
    }
    else {
        $1->right = $2;
        $3->left = $1;
    }
    $$ = $3;
}| {
    $$ = nullptr;
}
;
factor : factor_prefix postfix_expr {
    if ($1 == nullptr) {
        $$ = $2;
    }
    else {
        $1->right = $2;
        $$ = $1;
    }
};
factor_prefix : factor_prefix postfix_expr mulop {
    if ($1 == nullptr) {
        $3->left = $2;
    }
    else {
        $1->right = $2;
        $3->left = $1;
    }
    $$ = $3;
} | {
    $$ = nullptr;
}
;
postfix_expr : primary { $$ = $1;}| call_expr { $$ = $1; };
call_expr : id '(' expr_list ')' {
    $$ = new ASTNode_CALLEXPR(*($1), $3);
};
expr_list : expr expr_list_tail {
    $$ = $2;
    $$->push_back($1);
} | {
    vector<ASTNode*>* tmp = new vector<ASTNode*>;
    $$ = tmp;
}
;
expr_list_tail : ',' expr expr_list_tail {
    $$ = $3;
    $$->push_back($2);
} | {
    vector<ASTNode*>* tmp = new vector<ASTNode*>;
    $$ = tmp;
}
;
primary : '(' expr ')' { $$ = $2; } | id { $$ = new ASTNode_ID(ST->findEntry(*$1)); }
    | INTLITERAL {
        $$ = new ASTNode_INT($1);
    } 
    | FLOATLITERAL {
        $$ = new ASTNode_FLOAT($1);
    };
addop : '+' { $$ = new ASTNode_EXPR("+"); } | '-' { $$ = new ASTNode_EXPR("-"); };
mulop : '*' { $$ = new ASTNode_EXPR("*"); } | '/' { $$ = new ASTNode_EXPR("/"); };

/* Complex Statements and Condition */
if_stmt : IF {ST->addTable();} '(' cond ')' decl stmt_list {
    WC->lb++;
    WC->lblist.push_front(WC->lb);
    WC->codelines.push_back(new ERline(WC->symbolTable->STstack.top()->scope, "JUMP", "LABEL" + to_string(WC->lb)));
    int x = WC->lblist.back();
    WC->lblist.pop_back();
    WC->codelines.push_back(new ERline(WC->symbolTable->STstack.top()->scope, "LABEL", "LABEL" + to_string(x)));
    ST->pop_table();
} else_part FI {
    int x = WC->lblist.front();
    WC->lblist.pop_front();
    WC->codelines.push_back(new ERline(WC->symbolTable->STstack.top()->scope, "LABEL", "LABEL"+to_string(x)));
};
else_part : ELSE {ST->addTable();} decl stmt_list {ST->pop_table();} |
;
cond : expr compop expr {
    $2->left = $1;
    $2->right = $3;
    $2->getCode(WC);
};
compop : '<' { $$ = new ASTNode_COND("<"); } | '>' { $$ = new ASTNode_COND(">"); } | '=' { $$ = new ASTNode_COND("="); } | '!''=' { $$ = new ASTNode_COND("!="); } | '<''=' { $$ = new ASTNode_COND("<="); } | '>''=' { $$ = new ASTNode_COND(">="); };

init_stmt : assign_expr |
;
incr_stmt : for_assign_expr  { $$ = $1; } | { $$ = nullptr; }
;

for_assign_expr: id ':''=' expr {
    ASTNode* node = new ASTNode_ASSIGN(ST->findEntry(*$1));
    node->right = $4;
    $$ = node;
};

for_stmt : FOR {
        ST->addTable();
} '(' init_stmt ';' {
    WC->lb++;
    WC->lblist.push_front(WC->lb);
    WC->codelines.push_back(new ERline(WC->symbolTable->STstack.top()->scope, "LABEL", "LABEL"+to_string(WC->lb)));
} cond XX;

XX : ';' incr_stmt ')' decl aug_stmt_list ROF { 
    if ($2 != nullptr) {
        ($2)->getCode(WC);
        int x = WC->lblist.front();
        WC->lblist.pop_front();
        WC->codelines.push_back(new ERline(WC->symbolTable->STstack.top()->scope, "JUMP", "LABEL"+to_string(x)));

        x = WC->lblist.back();
        WC->lblist.pop_back();
        WC->codelines.push_back(new ERline(WC->symbolTable->STstack.top()->scope, "LABEL", "LABEL"+to_string(x)));

        ST->pop_table();
    }
    else {
        int x = WC->lblist.front();
        WC->lblist.pop_front();
        WC->codelines.push_back(new ERline(WC->symbolTable->STstack.top()->scope, "JUMP", "LABEL"+to_string(x)));

        x = WC->lblist.back();
        WC->lblist.pop_back();
        WC->codelines.push_back(new ERline(WC->symbolTable->STstack.top()->scope, "LABEL", "LABEL"+to_string(x)));

        ST->pop_table();
    }
}
;

aug_stmt_list : aug_stmt aug_stmt_list |
;
aug_stmt : base_stmt | aug_if_stmt | for_stmt | CONTINUE ';' {
    int x = WC->lblist.front();
    WC->codelines.push_back(new ERline(WC->symbolTable->STstack.top()->scope, "JUMP", "LABEL"+ to_string(x)));
} | BREAK ';' {
    int x = WC->lblist.front();
    x++;
    WC->codelines.push_back(new ERline(WC->symbolTable->STstack.top()->scope, "JUMP", "LABEL"+ to_string(x)));
};

aug_if_stmt : IF {ST->addTable();} '(' cond ')' decl aug_stmt_list {
    WC->lb++;
    WC->lblist.push_front(WC->lb);
    WC->codelines.push_back(new ERline(WC->symbolTable->STstack.top()->scope, "JUMP", "LABEL" + to_string(WC->lb)));
    int x = WC->lblist.back();
    WC->lblist.pop_back();
    WC->codelines.push_back(new ERline(WC->symbolTable->STstack.top()->scope, "LABEL", "LABEL" + to_string(x)));
    ST->pop_table();
} aug_else_part FI {
    int x = WC->lblist.front();
    WC->lblist.pop_front();
    WC->codelines.push_back(new ERline(WC->symbolTable->STstack.top()->scope, "LABEL", "LABEL"+to_string(x)));
};
aug_else_part : ELSE {ST->addTable();} decl aug_stmt_list {ST->pop_table();} |
;

%%