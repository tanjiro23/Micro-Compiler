compiler : scanner.l parser.y symboltable.cpp
	@bison -d parser.y
	@flex scanner.l
	@g++ -std=c++17 parser.tab.c lex.yy.c -o compiler

dev:
	@echo "Ayush Gupta\n190030007@iitdh.ac.in"

clean:
	@rm -f lex.yy.c compiler parser.tab.c parser.tab.h