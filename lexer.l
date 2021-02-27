%option noyywrap

%{ 
	#include "parser.h"
	#include <iostream>
	
	#pragma warning(disable : 4996)
	//Tablica zmiennych
	char *dict[1000];
	int dict_size=0;

	//odnajduje | dodaje zmienn¹ do tablicy
	int dict_find(const char *key) {
	int i;
		for(i=0; i<dict_size; i++){
		if(strcmp(key,dict[i])==0)
		return i;
		}

		i=dict_size;
		dict_size++;
		dict[i]=(char *)malloc(strlen(key)+1);
		strncpy(dict[i],key,strlen(key)+1);
		return i;
	}
%}

NUMB	[0-9]+
ID		[a-z][A-Za-z0-9]*



%%
"set"			{ return CMD_SET; }
"print("		{return CMD_PRINT;}
"readint"		{return CMD_READINT;}
"length("		{return CMD_LENGTH;}
"position("		{return CMD_POSITION;}
"readstr"		{return CMD_READSTR;}
"concatenate"	{return CMD_CONCATENATE;}
"substring("	{return CMD_SUBSTRING;}
"and"			{return AND;}
"or"			{return OR;}
"true"			{return TRUE;}
"false"			{return FALSE;}
"not"			{return NOT;}
"begin"			{return BEGIN_B; }
"end"			{return END_E;}
"while"			{return WHILE;}
"do"			{return DO;}
"if"			{return IF;}
"else"			{return ELSE;}
"then"			{return THEN;}
"<>"			{return NEQV2; }
"="				{return yytext[0];}
"<"				{return yytext[0];}
"<="			{return LESSEQ;}
">"				{return yytext[0];}
">="			{return GREATEQ;}
"=="			{return EQV;}
"!="			{return NEQV;}
"exit"			{return EXIT;}
{NUMB}			{ yylval.num = atoi(yytext); return NUM; }
{ID}			{ yylval.num = dict_find(yytext); return(IDENT);}
\"[A-Za-z]+\"	{ yylval.string = (char*)calloc(strlen(yytext)-1, sizeof(char));
				strncpy(yylval.string, &yytext[1], strlen(yytext)-2); return STRING;}
[+*/()-,]		{ return yytext[0]; }
[%;]			{ return yytext[0];}
":="			{ return ASSIGN;}
[\n]			{ return '\n'; }
[ \t]			{ /* empty */ }
.				/* nothing, eat up */

%%
