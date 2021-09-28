calc: Compiled_flex  Compiled_bison
	gcc -o calc calc.tab.c lex.yy.c -lfl

Compiled_bison: calc.y
	bison -dv calc.y

Compiled_flex: calc.l
	flex calc.l
