%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char *temp1[100];
int temp1cnt = 0;
float temp2;

int lcnt;
int i=0;
int k=0;
int p=0;

int flag=0;
int match = 0;
%}

%token TOK_SEMICOLON TOK_SUB TOK_MUL TOK_NUM TOK_PRINT TOK_FLOAT TOK_MAIN TOK_ID TOK_ASSIGN TOK_OB TOK_CB TOK_SCOPE_O TOK_SCOPE_C

%union{
        float fnum;
	struct stable s;
	struct optable o;
}

%code requires {
	struct stable
	{
		char temp[32];
		int vcnt;
		int tlcnt;

		float value[50];
		char var[50][32];
	};

	struct optable
	{
		int expression[22];
		float values[22];
		char variable[22][32]; 
	};
}

%code {
	struct stable level[50];
		
	int find(char *x)
	{
		match = 0;

		while(lcnt>0)	
		{
			for(i=0; i<level[lcnt].vcnt; i++)
			{
				if(strcmp(level[lcnt].var[i], x) == 0)
				{
					match = 1;
					return(i);
				}
			}
			lcnt--;
		}
		if(match == 0)
		{
			yyerror("Variable not found.");
			return(1);
		}	
	}
}

%type <fnum> TOK_NUM
%type <fnum> e
%type <s> TOK_ID
%type <s> id 

%left TOK_ASSIGN
%left TOK_SUB
%left TOK_MUL


%%
prog:
	TOK_MAIN TOK_SCOPE_O stmts TOK_SCOPE_C	
;


stmts:
	| stmt TOK_SEMICOLON stmts
;


stmt:
	TOK_FLOAT id			{
						lcnt = yylval.s.tlcnt;	
						strcpy(level[lcnt].var[level[lcnt].vcnt], temp1[temp1cnt-1]); 		
						level[lcnt].value[level[lcnt].vcnt] = 0.0; 	
						level[lcnt].vcnt++;
				}
	| id TOK_ASSIGN e		{
						lcnt = yylval.s.tlcnt;
						i = find(temp1[temp1cnt-(flag+1)]);
						level[lcnt].value[i] = temp2;
						flag = 0;
				}	
	| TOK_PRINT id			{
						lcnt = yylval.s.tlcnt;
						i = find(temp1[temp1cnt-1]);
						fprintf(stdout, "The value of %s is %.1f\n", level[lcnt].var[i], level[lcnt].value[i]);
				}
	| TOK_SCOPE_O stmts TOK_SCOPE_C	
;


e: 	 
	floatd				
	| id				{
						flag++;	
				}
	| e TOK_SUB e			{
						k = 1;
						while(k < 22)
						{
							if(yylval.o.expression[k] == 1)
							{
								if(yylval.o.expression[k-1] == 3 || yylval.o.expression[k-1] == 5)
								{
									$<fnum>1 = yylval.o.values[k-1];
								}
								else if(yylval.o.expression[k-1] == 4)
								{
									lcnt = yylval.s.tlcnt;
									i = find(yylval.o.variable[k-1]);
									$<fnum>1 = level[lcnt].value[i]; 	
								}		
						
								if(yylval.o.expression[k+1] == 3 || yylval.o.expression[k+1] == 5)
                                                                {
                                                                        $<fnum>3 = yylval.o.values[k+1];
                                                                }
                                                                else if(yylval.o.expression[k+1] == 4)
								{
									lcnt = yylval.s.tlcnt;	
									i = find(yylval.o.variable[k+1]);	
                                                                        $<fnum>3 = level[lcnt].value[i]; 
								}                
								
								break;
							}
							k++;
						}
						
						$<fnum>$ = $<fnum>1 - $<fnum>3; 
						temp2 = $<fnum>$;

						yylval.o.expression[k] = 0;
						yylval.o.expression[k-1] = 5;
						yylval.o.expression[k+1] = 5;

						for(p=k-1; p>=1; p--) 
						{
							if(yylval.o.expression[p] == 5 && (yylval.o.expression[p-1] != 1 || yylval.o.expression[p-1] != 2)){
								yylval.o.values[p] = temp2;
							}
						}

						for(p=k+1; p<22; p++)
                                                {
                                                        if(yylval.o.expression[p] == 5 && (yylval.o.expression[p+1] != 1 || yylval.o.expression[p+1] != 2))    { 
                                                                yylval.o.values[p] = temp2;        
							}
                                                } 
				}
	| e TOK_MUL e			{
						k = 1;
                                                while(k < 22)
                                                {
                                                        if(yylval.o.expression[k] == 2)
                                                        {
								if(yylval.o.expression[k-1] == 3 || yylval.o.expression[k-1] == 5)
                                                                {
                                                                        $<fnum>1 = yylval.o.values[k-1];
                                                                }
                                                                else if(yylval.o.expression[k-1] == 4)
                                                                {
                                                                        lcnt = yylval.s.tlcnt;
                                                                        i = find(yylval.o.variable[k-1]);
                                                                        $<fnum>1 = level[lcnt].value[i];
                                                                }

								if(yylval.o.expression[k+1] == 3 || yylval.o.expression[k+1] == 5)
                                                                {       
                                                                        $<fnum>3 = yylval.o.values[k+1];
                                                                }  
                                                                else if(yylval.o.expression[k+1] == 4)
                                                                {
                                                                        lcnt = yylval.s.tlcnt;
                                                                        i = find(yylval.o.variable[k+1]);
                                                                        $<fnum>3 = level[lcnt].value[i];
                                                                }

                                                                break;
                                                        }
                                                        k++;
                                                }

                                                $<fnum>$ = $<fnum>1 * $<fnum>3;
                                                temp2 = $<fnum>$;

                                                yylval.o.expression[k] = 0;
                                                yylval.o.expression[k-1] = 5;
                                                yylval.o.expression[k+1] = 5;

                                                for(p=k-1; p>=1; p--)
                                                {
                                                        if(yylval.o.expression[p] == 5 && (yylval.o.expression[p-1] != 1 || yylval.o.expression[p-1] != 2)){
                                                                yylval.o.values[p] = temp2;
                                                        }
                                                }

                                                for(p=k+1; p<22; p++)
                                                {
                                                        if(yylval.o.expression[p] == 5 && (yylval.o.expression[p+1] != 1 || yylval.o.expression[p+1] != 2))    {
                                                                yylval.o.values[p] = temp2;
                                                        }
                                                }
				}
	| TOK_OB TOK_SUB floatd TOK_CB	{
						$<fnum>$ = -1 * temp2; 
						temp2 = -1 * temp2; 
				}
;


floatd:
	TOK_NUM				{
						$<fnum>$ = $<fnum>1; 
						temp2 = $<fnum>$;
				}
;


id:
	TOK_ID				{
						temp1[temp1cnt] = $<s>1.temp;
						temp1cnt++;
				}
;


%%


int yyerror(char *str)
{
	extern int yylineno;
	printf("Parsing error: line %d - %s\n", yylineno, str);
	return 1; 
}


int main()
{
	struct stable level[50];
   	yyparse();
   	return 0;
}
