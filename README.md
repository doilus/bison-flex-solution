# Table of contents
* [General info](#general-info)
* [Task](#task)
* [Language grammar](#language-grammar)

# General info
This is an code analyzer and calculator for expressions on strings.

# Task
* use Flex and Bison for C++
* analyze the program that is written in language(below) and checks its correctness and compatibility
* run the program

# Language grammar

* arithmetic operators
```
num_op = "+" | "-" | "*" | "/" | "%"
```
* numeric expression
```
num_expr = NUM | IDENT
| "readint"
| "-" num_expr
| num_expr num_op num_expr
| "(" num_expr ")"
| "length(" str_expr ")"
| "position(" str_expr "," str_expr ")"
```
* string expression
```
str_expr = STRING | IDENT
| "readstr"
| "concatenate(" str_expr "," str_expr ")"
| "substring(" str_expr "," num_expr "," num_expr ")"
```
* logical operators
```
bool_op = "and" | "or"
```
* logical relations
```
num_rel = "=" | "<" | "<=" | ">" | ">=" | "<>"
str_rel = "==" | "!="
bool_expr = "true" | "false"
| "(" bool_expr ")"
| "not" bool_expr
| bool_expr bool_op bool_expr
| num_expr num_rel num_expr
| str_expr str_rel str_expr
```
* simple statements
```
simple_instr = assign_stat 
| if_stat
| while_stat
| "begin" instr "end"
| output_stat
| "exit"
```
* a string of statements
```
instr = instr ";" simple_instr | simple_instr
```
* assignment
```
assign_stat = IDENT ":=" num_expr
| IDENT ":=" str_expr
```
* conditional statement
```
if_stat = "if" bool_expr "then" simple_instr
| "if" bool_expr "then" simple_instr "else" simple_instr
```
* loop "while"
```
while_stat = "while" bool_expr "do" simple_instr
| "do" simple_instr "while" bool_expr
```
* show output
```
output_stat = "print(" num_expr ")"
| "print(" str_expr ")"
```
* program statements
```
program = instr
```

