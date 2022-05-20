compiler: main.c parser.y scanner.l
	@bison -d -o parser.c parser.y
	@flex scanner.l
	@gcc lex.yy.c parser.c main.c -o parse

clean:
	@rm -f lex.yy.c parser.c parser.h parse

dev: 
	@echo "Ayush Gupta\n190030007@iitdh.ac.in"