%defines "parser.h"

%{
	#define _CRT_SECURE_NO_WARNINGS
	#include <stdio.h>
	#include <cstring>
	#include <iostream>
	#include <string>
	#include <sstream>
	#define bzero(b,len) (memset((b), '\0', (len)), (void) 0)

	//Tablica wartoœci zmiennych
	int d_value[1000];
	char *s_value[1000];

	//Odszukanie wartoœci int
	int dict_value(int key){
		return d_value[key];
	}

	//odszukanie wartoœci string
	char* dict_value_str(int key){
		return s_value[key];
	}



	//Przypisanie wartoœci int
	void dict_set(int key, int value){
		d_value[key]=value;
	}

	//Przypisanie wartoœci string
	void dict_set_str(int key, char* value){
		s_value[key]=value;
	}

	
	int yylex(void);
	void yyerror(const char *);
	extern int yyparse();

	int pos;
	char result[80];

	char* concatenate(char * c, char *b){
	strcpy(result,c);
	strcat(result,b);
	return result; 
	}

	bool expresion = false;
	
%}
%union {
	signed long int num;
	int pos;
	char *string;
}
%token CMD_PRINT 
%token CMD_SET
%token<num> NUM
%token<num> IDENT
%token<string> STRING
%token ASSIGN
%token CMD_READINT
%token CMD_LENGTH
%token CMD_POSITION
%token CMD_READSTR
%token CMD_CONCATENATE
%token CMD_SUBSTRING
%token OR
%token AND
%token TRUE
%token FALSE
%token EXIT

%token EQV
%token NEQV
%token NEQV2
%token LESSEQ
%token GREATEQ
%token NOT
%token IF
%token ELSE
%token THEN
%token DO
%token WHILE
%token BEGIN_B
%token END_E

%left IF ELSE
%left NEQ2 LESSEQ GREATEQ EQV NEQV



%type<num> instr
%type<num> exp
%type<num> skl
%type<num> czy
%type<string> str_exp
%type<num> bool_expr
%type<num> str_rel
%type<num> num_rel
%type<num> bool_op
%type<string> output_stat_str
%type<num> output_stat_num 
%type<num> simple_instr
%type<num> if_stat



%%	

input: %empty
	| input program;
	;

program : instr;

instr :  simple_instr 
	| instr ';' simple_instr

	;

exp : exp '+' skl {$$ = $1 + $3;}
	| exp '-' skl {$$ = $1 - $3;}
	| skl
	;


skl : skl '*' czy {$$ = $1 * $3;}
	| skl '/' czy {$$ = $1 / $3;}
	| exp '%' czy	{ $$ = $1 * $3 / 100;} //wyliczony procent
	| czy
	;

czy : NUM
	| '-' NUM	{$$ = $2 <= 0 ? $2 : -$2;} //liczby ujemne *signed long int*
	| '(' exp ')' {$$ = $2;}
	| IDENT { $$=$1;
	int i = 0; 
	char* c = 0; 
	i = dict_value($1); 
	c = dict_value_str($1); 
	if(i != NULL || i==0){ 
	$$ = dict_value($1); 
	} 
	if(c!= NULL){ printf("%s\n", dict_value_str($1));}}
	;

	//dla stringów
str_exp : STRING 
	;

bool_op : AND {$$=1;}
	| OR {$$=0;}
	;

num_rel : exp '=' exp {if($1 == $3){$$ = 1;}else $$=0;}
	| exp '<' exp  {if($1 < $3){$$=1;}else $$=0;}
	| exp LESSEQ exp {if($1 <= $3){$$=1;}else $$=0;}
	| exp '>' exp {if($1 > $3){$$=1;}else $$=0;}
	| exp GREATEQ exp {if($1 >= $3){$$=1;}else $$=0;}
	| exp NEQV2 exp {if($1 != $3){$$=1;}else $$=0;}
	;

bool_expr : TRUE {$$=1;}
	| FALSE {$$=0;}
	| '(' bool_expr ')'
	| str_rel {$$=$1;}
	| num_rel {$$=$1;}
	| bool_expr bool_op bool_expr {
	if($2 == 1){
	if($1 == 1 && $3 == 1){$$=1;}
	else {$$=0;}}
	if($2 == 0){
	if($1 == 1 || $3 ==1) {$$=1;}
	else {$$=0;}}
	}
	| NOT bool_expr {if($2==1){$$=0;}else $$=1;}
	;

str_rel : str_exp EQV str_exp { std::string str1; std::string str2; str1+=$1;str2+=$3;if(str1 == str2){$$=1;}else $$=0;}
	| str_exp NEQV str_exp {std::string str1; std::string str2; str1+=$1;str2+=$3;if(str1 != str2){$$=1;}else $$=0;}
	;

simple_instr :  assign_stat_num '\n'
	| assign_stat_str '\n'
	| BEGIN_B instr END_E '\n' {$$=$2;}
	| output_stat_str '\n' { printf("%s\n", $1);}  
	| output_stat_num '\n' { printf("%d\n",$1);}
	| EXIT 				{ printf("%s\n", "Do widzenia!"); exit(0);}
	| CMD_LENGTH str_exp ')' '\n' {printf("%d\n", strlen($2));}
	| CMD_POSITION str_exp ',' str_exp ')' '\n'	{std::string str1; std::string str2; str1+=$2;str2+=$4; printf("%d\n", str1.find(str2));}
	| CMD_CONCATENATE '(' IDENT ',' IDENT ')' '\n' { printf("%s\n", concatenate((dict_value_str($3)),(dict_value_str($5))));} //dodatkowo wartosc dla zmiennych
	| CMD_CONCATENATE '(' str_exp ',' str_exp ')' '\n' { {printf("%s\n", concatenate($3,$5));}}
	| CMD_SUBSTRING str_exp ',' czy ',' czy ')' '\n'	{std::string str1;str1+=$2;int i1=$4; int i2=$6; std::string str2; str2+= str1.substr(i1,i2); printf("%s\n", str2);} 
	| CMD_READSTR str_exp '\n' {{printf("%s\n", $2);}}
	| bool_expr '\n' {if($$==1){printf("%s\n", "TRUE");}else printf("%s\n", "FALSE");}
	| if_stat '\n'
	;
assign_stat_num : CMD_SET IDENT ASSIGN exp  {dict_set($2,$4);}
	;
assign_stat_str : CMD_SET IDENT ASSIGN str_exp  {dict_set_str($2, $4);}
	;
output_stat_str : CMD_PRINT str_exp ')' {$$ = $2;}
	;
output_stat_num : CMD_PRINT exp ')' {$$= $2;}
	;
	

if_stat : IF bool_expr THEN simple_instr {if($2==1){$$=$4;}else $$=0;}
	| IF bool_expr THEN simple_instr ELSE simple_instr {if($2==1){$$=4;}else $$=6;}
	;
	
while_stat : WHILE bool_expr DO simple_instr 
	| DO simple_instr WHILE bool_expr
	;
%%

int main(){
	yyparse();

}

void yyerror(const char* msg)
{
	
	fprintf(stderr, "%s\n", msg);
}


