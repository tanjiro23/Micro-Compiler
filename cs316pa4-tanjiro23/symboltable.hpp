#pragma once
#include <iostream>
#include <stack>
#include <vector>
#include <assert.h>
#include <map>
#include <algorithm>

using namespace std;

class tableEntry
{
public:
    string name, type, value;
    bool isPara = false;

    tableEntry(string name, string type, bool isPara)
    {
        this->name = name;
        this->type = type;
        this->isPara = isPara;
    }

    tableEntry(string name, string type, string value)
    {
        this->name = name;
        this->type = type;
        this->value = value;
    }

    tableEntry()
    {
        ;
    }

    tableEntry(string name, string type)
    {
        this->name = name;
        this->type = type;
    }
};

class symbol_table
{
public:
    string scope;
    map<string, tableEntry> symbolTable;
    vector<tableEntry> tableEntries;

    symbol_table(string scope)
    {
        this->scope = scope;
    }

    bool isUsed(string name)
    {
        if (symbolTable.find(name) != symbolTable.end())
        {
            return true;
        }
        return false;
    }

    bool add(string name, string type)
    {
        tableEntry declaration(name, type);
        if (!isUsed(declaration.name))
        {
            symbolTable[declaration.name] = declaration;
            tableEntries.push_back(declaration);
            return true;
        }
        return false;
    }

    bool add(string name, string type, string value)
    {
        tableEntry declaration(name, type, value);
        if (!isUsed(declaration.name))
        {
            symbolTable[declaration.name] = declaration;
            tableEntries.push_back(declaration);
            return true;
        }
        return false;
    }

    bool add(string name, string type, bool isPara)
    {
        tableEntry declaration(name, type, isPara);
        if (!isUsed(declaration.name))
        {
            symbolTable[declaration.name] = declaration;
            tableEntries.push_back(declaration);
            return true;
        }
        return false;
    }

    void printTable()
    {
        cout << "Symbol table " << scope << endl;
        for (auto item : tableEntries)
        {
            cout << "name " << item.name << " type " << item.type;
            if (item.value.length())
            {
                cout << " value " << item.value;
            }
            cout << endl;
        }
    }

    tableEntry *findEntry(string name)
    {
        if (symbolTable.find(name) != symbolTable.end())
        {
            tableEntry *entry = &symbolTable[name];
            return entry;
        }
        return new tableEntry();
    }
};

class ST_stack
{
public:
    string error = "";
    stack<symbol_table *> STstack;
    vector<symbol_table *> STvector;
    int block_cnt = 1;

    void addTable(string name)
    {
        symbol_table *table = new symbol_table(name);
        STstack.push(table);
        STvector.push_back(table);
    }

    void addTable()
    {
        string name = "BLOCK " + to_string(block_cnt);
        symbol_table *table = new symbol_table(name);
        STstack.push(table);
        STvector.push_back(table);
        block_cnt++;
    }

    void addDecl(string name, string type, string value)
    {
        bool status = STstack.top()->add(name, type, value);
        if (!status && error == "")
        {
            error = name;
        }
    }

    void addDecl(string name, string type)
    {
        bool status = STstack.top()->add(name, type);
        if (!status && error == "")
        {
            error = name;
        }
    }

    void addDecl(string name, string type, bool isPara)
    {
        bool status = STstack.top()->add(name, type, isPara);
        if (!status && error == "")
        {
            error = name;
        }
    }

    void pop_table()
    {
        assert(STstack.size() > 0);
        STstack.pop();
    }

    void printStack()
    {
        if (error != "")
        {
            cout << "DECLARATION ERROR " + error << endl;
            return;
        }

        for (int i = 0; i < (int)STvector.size(); ++i)
        {
            STvector[i]->printTable();
            if (i != (int)STvector.size() - 1)
                cout << endl;
        }
    }

    tableEntry *findEntry(string name, string scope)
    {
        for (auto table : STvector)
        {
            if (table->scope == scope)
            {
                return table->findEntry(name);
            }
        }
        return new tableEntry();
    }

    tableEntry *findEntry(string name)
    {
        stack<symbol_table *> curStack = STstack;
        while (!curStack.empty())
        {
            if (curStack.top()->isUsed(name))
            {
                return curStack.top()->findEntry(name);
            }
            curStack.pop();
        }
        return new tableEntry();
    }
};