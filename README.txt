README file

1. Group Members - 

	Name:	Shriram Ananda Suryawanshi
	Email: 	ssuryaw1@binghamton.edu



2. The code is tested on bingsuns.



3. Program Execution - 
	
	To execute the program, use the makefile to compile both calc.l and calc.y files. 
	Once, the compilation is done, you can use "./calc" command with either input file or with command line input.



4. Algorithm - 

	We have implemented the float calculator for two operations - Subtraction and Multiplication. The calculator will accept the input in the form of C program.

	The grammer for this is - 
		Prog --> main(){Stmts}
		Stmts --> e | Stmt; Stmts
		Stmt --> float Id| Id = E | print Id |{Stmts}
		E --> Float | Id | E - E | E * E| (-Float)
		Float --> digit+ . digit+

	Variable Storage - 
		We've used structure (stable) to maintain the symbol table. The two arrays - var[] and value[] will maintain the variable and it's corresponding value. 
		For each new scope (i.e. {}), we create a new object of structure, and all the variables belonging to this scope will be assigned to this object only.

	Accessing the variable value - 
		To get the value for any variable, we will first scan the list of variables stored in the current scope object (structure stable object). if we found the variable, we will use it's corresponding value.
		If we do not find variable in the current scope (which means, required variable might be belonging to parent scope), we will traverse through the outer scope.
		This will continue until we find variable.
		In case, if we don't find it, we will throw error - "Variable not defined."

	Keeping variable track - 
		Whenever any variable encountered in the program, we store it in the array (temp1). By this way, we can keep track of what variable need to use for what purpose in larger assignment operations.
		E.g. x =  a - b - c - d;	For this, operation, last variable provided by lex file will be 'd', but we have to use 'x' for the assignment operation. 
		Hence, we will count the number of variables encountered after assign (=) using variable 'flag', and will use our array to determine the correct variable to assign the value.
		
	Evaluating Expressions - 
		Expressions might be combination of any number of float values, variables, subtraction and multiplication operations. To keep the track, we have implemented another structure (optable).
		It has three arrays - 
			expression : It will tell what kind of value expression has. It will hold 0 for empty, 1 for subtraction, 2 for multiplication, 3 for float value, 4 for variable and 5 for the result of other expression.
				So, for example, x = 3.0 - y;	will hold the values 3 1 4
			values: This will hold the corresponding float values from the expression. So, whenever we find value 3 in expression array, we will use the value from corresponding position of this array.
			variable:	This is same as above, but will gold variable names.
		Based on the evaluation of expression, we will keep the results back into the 'values' for further evaluations.


5. Important Instructions - 
	We have defined only 50 object for stable structure. That means, the program can support only upto 50 nesting scopes ({..}).
	The value of the indentifier should not be more than 32 characters as per C standards.
	We can eveluate maximum 10 operations with 21 operands in one expession. (i.e. x = a - b * c - d...; this can have togethermaximum of 10 subtraction or multiplications.
	The gcc throw one warning, but it doesn't affect execution of the program.


Thank You!
