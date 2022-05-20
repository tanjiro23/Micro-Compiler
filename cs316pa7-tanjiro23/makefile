compiler :
	@bison -d parser.y -o parser.c
	@flex scanner.l
	@g++ -std=c++17 main.cpp lex.yy.c -o compiler

dev:
	@echo "Ayush Gupta\n190030007@iitdh.ac.in"

clean:
	@rm -f lex.yy.c compiler parser.c parser.h tiny

tiny:
	@g++-9 -o tiny tiny4regs.C

tinyold:
	@g++-9 -o tinyold tinyNew.C