#pragma once
#include <iostream>
#include <string>
#include <vector>
#include "symboltable.hpp"
#include <deque>

using namespace std;

class ERline
{
public:
    string command;
    string argument1;
    string argument2;
    string argument3;
    string scope;

    ERline(string scope, string command, string argument1, string argument2)
    {
        this->argument1 = argument1;
        this->argument2 = argument2;
        this->argument3 = "";
        this->scope = scope;
        this->command = command;
    }

    ERline(string scope, string command, string argument1, string argument2, string argument3)
    {
        this->argument1 = argument1;
        this->argument2 = argument2;
        this->argument3 = argument3;
        this->scope = scope;
        this->command = command;
    }

    ERline(string scope, string command, string argument1)
    {
        this->argument1 = argument1;
        this->argument2 = "";
        this->argument3 = "";
        this->scope = scope;
        this->command = command;
    }

    void print()
    {
        string val = command + " " + argument1;
        if (argument2 != "")
        {
            val += (" " + argument2);
        }
        if (argument3 != "")
        {
            val += (" " + argument3);
        }
        cout << val << " " << endl;
    }
};

class wholeCode
{
public:
    vector<ERline *> codelines;
    ST_stack *symbolTable;
    int tempRegister = 0;
    int lb = 0;
    deque<int> lblist;
    deque<int> lblistfor;

    wholeCode(ST_stack *symbolTable)
    {
        this->symbolTable = symbolTable;
    }

    string getTempVar()
    {
        return ("$T" + to_string(tempRegister++));
    }

    void ERwrite(string type, string name)
    {
        if (type == "INT")
        {
            this->codelines.push_back(new ERline(this->symbolTable->STstack.top()->scope, "WRITEI", name));
        }
        else if (type == "STRING")
        {
            this->codelines.push_back(new ERline(this->symbolTable->STstack.top()->scope, "WRITES", name));
        }
        else if (type == "FLOAT")
        {
            this->codelines.push_back(new ERline(this->symbolTable->STstack.top()->scope, "WRITEF", name));
        }
    }

    void ERread(string type, string name)
    {
        if (type == "INT")
        {
            this->codelines.push_back(new ERline(this->symbolTable->STstack.top()->scope, "READI", name));
        }
        else if (type == "FLOAT")
        {
            this->codelines.push_back(new ERline(this->symbolTable->STstack.top()->scope, "READF", name));
        }
    }

    void print()
    {
        cout << "size : " << (int)codelines.size() << "\n";
        for (auto line : codelines)
        {
            line->print();
        }
    }
};