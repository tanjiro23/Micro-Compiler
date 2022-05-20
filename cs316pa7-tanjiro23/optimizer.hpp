#pragma once
#include <iostream>
#include <set>
#include <string>
#include "abstractSyntaxTree.hpp"

using namespace std;

class assemblyCode
{
    map<ERline, set<string>> generate;
    map<ERline, set<string>> kill;
    map<ERline, set<string>> in;
    map<ERline, set<string>> out;
    map<ERline *, vector<ERline *>> predecessors;
    map<ERline *, vector<ERline *>> successors;
    vector<ERline> assembly;
    vector<string> global_var;
    vector<string> global_string;

    void setupCFG(wholeCode *code, vector<symbol_table *> STvector)
    {
        for (ERline *line : code->codelines)
        {
            string com = line->command;
            if (com == "VAR")
            {
                global_var.push_back(line->argument1);
            }
            else if (com == "STRING")
            {
                global_string.push_back(line->argument1);
            }
            vector<ERline *> slist, plist;
            predecessors[line] = plist;
            if (com == "RET")
            {
                successors[line] = slist;
                continue;
            }
            if (com == "JUMP")
            {
                for (ERline *toline : code->codelines)
                {
                    if (toline->op == "LABEL" && toline->argument1 == line->argument1)
                    {
                        slist.push_back(toline);
                        break;
                    }
                }
                successors[line] = slist;
            }
            if (com == "LE" || com == "GE" || com == "NE" || com == "GT" || com == "LT" || com == "EQ")
            {
                for (ERline *toline : code->codelines)
                {
                    if (toline)
                }
            }
        }
    }
}