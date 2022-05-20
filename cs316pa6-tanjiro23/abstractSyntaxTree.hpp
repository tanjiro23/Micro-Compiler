#pragma once
#include <iostream>
#include <vector>
#include <string>
#include "codeStruct.hpp"
#include <map>

using namespace std;

static string id_type;

class ASTNode
{
public:
    string type;
    ASTNode *left;
    ASTNode *right;

    virtual string getCode(wholeCode *code)
    {
        return "this is invalid";
    }
};

class ASTNode_ID : public ASTNode
{
public:
    string type = "ID";
    tableEntry *entry;

    ASTNode_ID(tableEntry *entry)
    {
        this->entry = entry;
    }

    string getCode(wholeCode *code)
    {
        return this->entry->name;
    }
};

class ASTNode_INT : public ASTNode
{
public:
    string type = "INT";
    int value = -1;

    ASTNode_INT(int value)
    {
        this->value = value;
    }

    string getCode(wholeCode *code)
    {
        string argument1 = to_string(value);
        string argument2 = code->getTempVar();
        string operation = "STOREI";

        code->codelines.push_back(new ERline(code->symbolTable->STstack.top()->scope, operation, argument1, argument2));

        return argument2;
    }
};

class ASTNode_FLOAT : public ASTNode
{
public:
    string type = "FLOAT";
    double value = -1.0;

    ASTNode_FLOAT(double value)
    {
        this->value = value;
    }

    string getCode(wholeCode *code)
    {
        string argument1 = to_string(value);
        string argument2 = code->getTempVar();
        string operation = "STOREF";
        code->codelines.push_back(new ERline(code->symbolTable->STstack.top()->scope, operation, argument1, argument2));

        return argument2;
    }
};

class ASTNode_ASSIGN : public ASTNode
{
public:
    string type = "ASSIGN";
    tableEntry *entry;

    ASTNode_ASSIGN(tableEntry *entry)
    {
        this->entry = entry;
        id_type = entry->type;
        this->left = new ASTNode_ID(entry);
    }

    string getCode(wholeCode *code)
    {
        string operation = (id_type == "INT" ? "STOREI" : "STOREF");
        string argument1 = this->right->getCode(code);
        string argument2 = this->left->getCode(code);
        code->codelines.push_back(new ERline(code->symbolTable->STstack.top()->scope, operation, argument1, argument2));

        return "";
    }
};

class ASTNode_EXPR : public ASTNode
{
public:
    string type = "EXPR";
    string opertr;
    map<pair<string, string>, string> op_mapping = {
        {{"INT", "+"}, "ADDI"},
        {{"FLOAT", "+"}, "ADDF"},
        {{"INT", "-"}, "SUBI"},
        {{"FLOAT", "-"}, "SUBF"},
        {{"INT", "*"}, "MULI"},
        {{"FLOAT", "*"}, "MULF"},
        {{"INT", "/"}, "DIVI"},
        {{"FLOAT", "/"}, "DIVF"},
    };

    ASTNode_EXPR(string op)
    {
        opertr = op;
    }

    string getCode(wholeCode *code)
    {
        string op = op_mapping[{id_type, opertr}];
        string argument1 = this->left->getCode(code);
        string argument2 = this->right->getCode(code);
        string tempVar = code->getTempVar();
        code->codelines.push_back(new ERline(code->symbolTable->STstack.top()->scope, op, argument1, argument2, tempVar));
        return tempVar;
    }
};

class ASTNode_COND : public ASTNode
{
public:
    string comp;

    ASTNode_COND(string comp)
    {
        this->comp = comp;
    }

    string getCode(wholeCode *code)
    {
        string op;
        string label;
        string argument1 = this->left->getCode(code);
        string argument2 = this->right->getCode(code);

        code->lb++;
        code->lblist.push_back(code->lb);
        // cerr << "lblist after cond class\n";
        // for (int i : code->lblist)
        // {
        //     cerr << i << " ";
        // }
        // cerr << "\n";
        label = "LABEL" + to_string(code->lb);

        if (comp == ">")
        {
            op = "LE";
        }
        else if (comp == "!=")
        {
            op = "EQ";
        }
        else if (comp == "<=")
        {
            op = "GT";
        }
        else if (comp == "=")
        {
            op = "NE";
        }
        else if (comp == ">=")
        {
            op = "LT";
        }
        else if (comp == "<")
        {
            op = "GE";
        }

        code->codelines.push_back(new ERline(code->symbolTable->STstack.top()->scope, op, argument1, argument2, label));

        return "";
    }
};

class ASTNode_CALLEXPR : public ASTNode
{
public:
    string type = "CALLEXPR";
    string funct_name = "";
    vector<ASTNode *> *parameter_list;

    ASTNode_CALLEXPR(string funct_name, vector<ASTNode *> *plist)
    {
        this->funct_name = funct_name;
        this->parameter_list = plist;
    }

    string getCode(wholeCode *code)
    {
        string comm = "PUSH";

        code->codelines.push_back(new ERline(code->symbolTable->STstack.top()->scope, comm, ""));

        for (auto &node : *parameter_list)
        {
            string para = node->getCode(code);
            code->codelines.push_back(new ERline(code->symbolTable->STstack.top()->scope, comm, para));
        }

        code->codelines.push_back(new ERline(code->symbolTable->STstack.top()->scope, comm + "R", ""));

        code->codelines.push_back(new ERline(code->symbolTable->STstack.top()->scope, "JSR", funct_name));

        code->codelines.push_back(new ERline(code->symbolTable->STstack.top()->scope, "POPR", ""));
        for (int i = 0; i < (int)(*parameter_list).size(); ++i)
        {
            code->codelines.push_back(new ERline(code->symbolTable->STstack.top()->scope, "POP", ""));
        }

        string temp = code->getTempVar();

        code->codelines.push_back(new ERline(code->symbolTable->STstack.top()->scope, "POP", temp));

        return temp;
    }
};
