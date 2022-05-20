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
        if (temp[0] == '#')
        {
            temp[0] = '$';
            return temp;
        }
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

    string getRegForID(string ID)
    {
        tempToReg[ID] = getNewReg();
        return tempToReg[ID];
    }

    assemblyCode(wholeCode *code, vector<symbol_table *> STvector)
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
            string farg1, farg2, farg3;

            auto frameVar = [&](string s, string scope) -> string
            {
                if (s[0] != '$')
                {
                    bool got = false;
                    for (int i = STvector.size() - 1; i >= 0; i--)
                    {
                        if (STvector[i]->scope == scope)
                        {
                            got = true;
                        }
                        if (got == true && STvector[i]->scope[0] != '$')
                        {
                            scope = STvector[i]->scope;
                            break;
                        }
                    }
                    symbol_table *curtable;
                    for (symbol_table *table : STvector)
                    {
                        if (table->scope == scope)
                        {
                            curtable = table;
                            break;
                        }
                    }

                    int no_parameters = 0;

                    for (int i = 0; i < (int)curtable->tableEntries.size(); i++)
                    {
                        if (curtable->tableEntries[i].isPara == true)
                        {
                            no_parameters++;
                        }
                    }

                    for (int i = 0; i < (int)curtable->tableEntries.size(); i++)
                    {
                        if (curtable->tableEntries[i].name == s)
                        {
                            if (curtable->tableEntries[i].isPara == true)
                            {
                                return "#" + to_string(6 + i);
                            }
                            return "#-" + to_string(i + 1 - no_parameters);
                        }
                    }
                }
                return s;
            };

            farg1 = frameVar(line->argument1, line->scope);
            farg2 = frameVar(line->argument2, line->scope);
            farg3 = frameVar(line->argument3, line->scope);

            string flag = "$";
            int no_parameters = 0;

            bool got = false;
            string scope = line->scope;
            for (int i = STvector.size() - 1; i >= 0; i--)
            {
                if (STvector[i]->scope == scope)
                {
                    got = true;
                }
                if (got == true && STvector[i]->scope[0] != '$')
                {
                    scope = STvector[i]->scope;
                    break;
                }
            }

            symbol_table *curtable;
            for (symbol_table *table : STvector)
            {
                if (table->scope == scope)
                {
                    curtable = table;
                    break;
                }
            }

            for (int i = 0; i < (int)curtable->tableEntries.size(); i++)
            {
                if (curtable->tableEntries[i].isPara == true)
                {
                    no_parameters++;
                }
            }

            flag += to_string(6 + no_parameters);

            if (com == "RET")
            {
                if (farg1[0] == '$')
                {
                    assembly.push_back(ERline(line->scope, "move", getWhatever(farg1), flag));
                    assembly.push_back(ERline(line->scope, "unlnk", ""));
                    assembly.push_back(ERline(line->scope, "ret", ""));
                }
                else
                {
                    string newR = getNewReg();
                    tempToReg[farg1] = newR;
                    assembly.push_back(ERline(line->scope, "move", getWhatever(farg1), newR));
                    assembly.push_back(ERline(line->scope, "move", newR, flag));
                    assembly.push_back(ERline(line->scope, "unlnk", ""));
                    assembly.push_back(ERline(line->scope, "ret", ""));
                }
            }

            if (com == "PUSH")
            {
                if (line->argument1 != "")
                {
                    assembly.push_back(ERline(line->scope, "push", getWhatever(farg1)));
                }
                else
                {
                    assembly.push_back(ERline(line->scope, "push", ""));
                }
            }

            if (com == "PUSHR")
            {
                assembly.push_back(ERline(line->scope, "push", "r0"));
                assembly.push_back(ERline(line->scope, "push", "r1"));
                assembly.push_back(ERline(line->scope, "push", "r2"));
                assembly.push_back(ERline(line->scope, "push", "r3"));
            }

            if (com == "LINK")
            {
                int cnt = 5;
                assembly.push_back(ERline(line->scope, "link", to_string(cnt)));
            }

            if (com == "JSR")
            {
                assembly.push_back(ERline(line->scope, "jsr", line->argument1));
            }

            if (com == "POP")
            {
                if (line->argument1 == "")
                {
                    assembly.push_back(ERline(line->scope, "pop", ""));
                }
                else
                {
                    assembly.push_back(ERline(line->scope, "pop", getWhatever(farg1)));
                }
            }

            if (com == "POPR")
            {
                assembly.push_back(ERline(line->scope, "pop", "r3"));
                assembly.push_back(ERline(line->scope, "pop", "r2"));
                assembly.push_back(ERline(line->scope, "pop", "r1"));
                assembly.push_back(ERline(line->scope, "pop", "r0"));
            }

            if (com == "STOREI" || com == "STOREF")
            {
                string newR = getNewReg();
                assembly.push_back(ERline(line->scope, "move", getWhatever(farg1), newR));
                assembly.push_back(ERline(line->scope, "move", newR, getWhatever(farg2)));
            }
            else if (com == "READI" || com == "READF")
            {
                assembly.push_back(ERline(line->scope, "sys", getLower(com), getWhatever(farg1)));
            }
            else if (com == "WRITEI" || com == "WRITEF" || com == "WRITES")
            {
                assembly.push_back(ERline(line->scope, "sys", getLower(com), getWhatever(farg1)));
            }
            else
            {
                const string Ids[] = {"ADD", "SUB", "DIV", "MUL"};
                const string cmps[] = {"GE", "GT", "LT", "LE", "NE", "EQ"};
                bool presentInID = false;
                for (string i : Ids)
                {
                    if (i == com.substr(0, 3))
                    {
                        assembly.push_back(ERline(line->scope, "move", getWhatever(farg1), getWhatever(farg3)));
                        assembly.push_back(ERline(line->scope, getLower(com), getWhatever(farg2), getWhatever(farg3)));
                        presentInID = true;
                        break;
                    }
                }
                for (string i : cmps)
                {
                    if (i == com)
                    {
                        if (line->argument2[0] != '$')
                        {
                            string temp = getRegForID(line->argument2);
                            assembly.push_back(ERline(line->scope, "move", getWhatever(farg2), temp));
                            string typee = "";
                            for (symbol_table *table : STvector)
                            {
                                if (table->symbolTable.find(line->argument1) != table->symbolTable.end())
                                {
                                    typee = table->symbolTable[line->argument1].type;
                                    break;
                                }
                            }
                            string newR = getNewReg();
                            assembly.push_back(ERline(line->scope, "move", getWhatever(farg2), newR));
                            if (typee == "INT")
                            {
                                assembly.push_back(ERline(line->scope, "cmpi", getWhatever(farg1), newR));
                            }
                            else
                            {
                                assembly.push_back(ERline(line->scope, "cmpr", getWhatever(farg1), newR));
                            }
                        }
                        else
                        {
                            string typee = "";
                            for (symbol_table *table : STvector)
                            {
                                if (table->symbolTable.find(line->argument1) != table->symbolTable.end())
                                {
                                    typee = table->symbolTable[line->argument1].type;
                                    break;
                                }
                            }
                            string newR = getNewReg();
                            assembly.push_back(ERline(line->scope, "move", getWhatever(farg2), newR));
                            if (typee == "INT")
                            {
                                assembly.push_back(ERline(line->scope, "cmpi", getWhatever(farg1), newR));
                            }
                            else
                            {
                                assembly.push_back(ERline(line->scope, "cmpr", getWhatever(farg1), newR));
                            }
                        }
                        assembly.push_back(ERline(line->scope, "j" + getLower(com), getWhatever(farg3)));
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
                // assert(presentInID == true);
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