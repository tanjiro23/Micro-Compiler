# Micro-Compiler

Developed a Micro compiler with the ability to work with loops (along with break and continue) and function calling

In order to run this compiler, please install 
- flex
- bison (version >= 3.5)
- gcc (version 9, Note that version 11 may cause error with tinyNew.C file)

> make compiler

This command is used to generate the executable, compiler.
Then, we use this executable to compile the micro files. 

``` ./runme micro-file.micro output-file ```

This command runs the micro file using our compiler and stores the assembly instructions in the output-file.

A simulator, _tiny_ is used for demo purpose. 

> ./tiny output-file

This executable tiny (generated after compiling the tiny.c file) runs the assembly instructions. 

In 1st step, a lexical analyser was written. In 2nd step, the rules for grammar were written in parser. In 3rd step,
symbol table was created. In 4th step, assembly instructions were created for if-else statements. In 5th step, assembly
instructions for loop were created. In 6th step, assembly instructions for function calling were implemented. In final step,
we optimized our compiler by using only 4 registers. This could be achieved by using Liveness analysis.

In the report, I have tried to extend my project to produce x86 assembly instructions. All the details are covered in the Report.
