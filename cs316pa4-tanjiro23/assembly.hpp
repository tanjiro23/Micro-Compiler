#pragma once
#include <iostream>
#include <vector>
#include <map>
#include "abstractSyntaxTree.hpp"
#include <string>

using namespace std;

class assemblyCode
{
public:
    int reg = 0;
    map<string, string> tempToReg;
    vector<ERline> assembly;

    string getNewReg()
    {
        return "r" + to_string(reg++);
    }

    string getWhatever(string temp)
    {
        if (temp[0] != '$')
        {
            return temp;
        }
        if (tempToReg.find(temp) != tempToReg.end())
        {
            return tempToReg[temp];
        }
        tempToReg[temp] = getNewReg();
        return tempToReg[temp];
    }

    bool isTemp(string temp)
    {
        return temp[0] == '$';
    }

    assemblyCode(wholeCode *code)
    {
        auto getLower = [&](string s) -> string
        {
            for (char &i : s)
            {
                i |= ' ';
            }
            if (s.back() == 'f')
            {
                s.back() = 'r';
            }
            return s;
        };

        for (ERline *line : code->codelines)
        {
            string com = line->command;
            if (com == "STOREI" || com == "STOREF")
            {
                assembly.push_back(ERline(line->scope, "move", getWhatever(line->argument1), getWhatever(line->argument2)));
            }
            else if (com == "READI" || com == "READF")
            {
                assembly.push_back(ERline(line->scope, "sys", getLower(com), getWhatever(line->argument1)));
            }
            else if (com == "WRITEI" || com == "WRITEF" || com == "WRITES")
            {
                assembly.push_back(ERline(line->scope, "sys", getLower(com), getWhatever(line->argument1)));
            }
            else
            {
                const std::string Ids[] = {"ADD", "SUB", "DIV", "MUL"};
                const std::string cmps[] = {"GE", "GT", "LT", "LE", "NE", "EQ"};
                bool presentInID = false;
                for (string i : Ids)
                {
                    if (i == com.substr(0, 3))
                    {
                        assembly.push_back(ERline(line->scope, "move", getWhatever(line->argument1), getWhatever(line->argument3)));
                        assembly.push_back(ERline(line->scope, getLower(com), getWhatever(line->argument2), getWhatever(line->argument3)));
                        presentInID = true;
                        break;
                    }
                }
                for (string i : cmps)
                {
                    if (i == com)
                    {
                        assembly.push_back(ERline(line->scope, "cmpi", getWhatever(line->argument1), getWhatever(line->argument2)));
                        assembly.push_back(ERline(line->scope, "j" + getLower(com), getWhatever(line->argument3)));
                        presentInID = true;
                        break;
                    }
                }
                if (com == "JUMP")
                {
                    assembly.push_back(ERline(line->scope, "jmp", line->argument1));
                    presentInID = true;
                }
                else if (com == "LABEL")
                {
                    assembly.push_back(ERline(line->scope, "label", line->argument1));
                    presentInID = true;
                }
                assert(presentInID == true);
            }
        }
    }

    void print()
    {
        for (auto line : assembly)
        {
            line.print();
        }
    }
};