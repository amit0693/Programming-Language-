%{
#include <stdio.h>
#include <stdlib.h>
#include "calc.tab.h"
int cnt = 0;
int ecnt = 1;
%}

%option nodefault
%option yylineno

digit	([0-9])

%%
"print"      		{return(TOK_PRINT);}
"float"			{return(TOK_FLOAT);}
"main()"		{return(TOK_MAIN);}
{digit}+"."{digit}+     {yylval.o.expression[ecnt] = 3; yylval.o.values[ecnt] = atof(yytext); ecnt++; sscanf(yytext, "%f", &(yylval.fnum)); return(TOK_NUM);}
";"			{return(TOK_SEMICOLON);}
"-"			{yylval.o.expression[ecnt] = 1; ecnt++; return(TOK_SUB);}
"*"			{yylval.o.expression[ecnt] = 2; ecnt++; return(TOK_MUL);}
"="			{ecnt = 1; return(TOK_ASSIGN);}
"("			{return(TOK_OB);}
")"			{return(TOK_CB);}
"{"			{cnt++; yylval.s.tlcnt = cnt; return(TOK_SCOPE_O);}
"}"			{cnt--; yylval.s.tlcnt = cnt; return(TOK_SCOPE_C);}	
[ \t\n]
[a-z][0-9a-zA-Z]*       {yylval.o.expression[ecnt] = 4; strcpy(yylval.o.variable[ecnt], yytext); ecnt++; strcpy(yylval.s.temp, yytext); return(TOK_ID);}
. 			{printf("Lexical analysis error: %s\n", yytext);}
%%

