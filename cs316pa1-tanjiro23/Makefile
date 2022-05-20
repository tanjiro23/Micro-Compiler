dev:
	@echo "Ayush Gupta\n190030007@iitdh.ac.in"

compiler: lex.yy.c
	@g++ $< -o compiler
lex.yy.c: scanner.l
	@flex $^

clean: lex.yy.c
	@rm lex.yy.c
