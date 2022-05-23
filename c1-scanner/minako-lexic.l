%option yylineno noyywrap nounput noinput nodefault

%{
#include "minako.h"

extern int fileno(FILE *stream);

void invalid_token() {
  fprintf(stderr, "Invalid Token: \"%s\"\n", yytext);
  exit(EXIT_FAILURE);
}
%}

%s STRING

BLOCK_COMMENT         "/*"((("*"[^/])?)|[^*])*"*/"
LINE_COMMENT          "//".*
INT                   [0-9]+
FLOAT                 [0-9]+"."[0-9]+|"."[0-9]+([eE]([-+])?[0-9]+)?|[0-9]+[eE]([-+])?[0-9]+
ID                    [[:alpha:]]+[[:alnum:]]*
PUNCTUATION           "+"|"-"|"*"|"/"|"="|"("|")"|"{"|"}"|","|";"
WHITESPACE            [ \t\n\r]

%%

{BLOCK_COMMENT}
{LINE_COMMENT}

bool                  return KW_BOOLEAN;
do                    return KW_DO;
else                  return KW_ELSE;
float                 return KW_FLOAT;
for                   return KW_FOR;
if                    return KW_IF;
int                   return KW_INT;
printf                return KW_PRINTF;
return                return KW_RETURN;
void                  return KW_VOID;
while                 return KW_WHILE;
"&&"                  return AND;
"||"                  return OR;
"=="                  return EQ;
"!="                  return NEQ;
">="                  return GEQ;
"<="                  return LEQ; 
">"                   return GRT;
"<"                   return LSS;

{INT}                 yylval.intValue = atoi(yytext); return CONST_INT;
{FLOAT}               yylval.floatValue = atof(yytext); return CONST_FLOAT;
true                  yylval.intValue = 1; return CONST_BOOLEAN;
false                 yylval.intValue = 0; return CONST_BOOLEAN;
\"                    BEGIN(STRING);
<STRING>[^\n\"]*/\"   yylval.string = yytext; BEGIN(INITIAL); return CONST_STRING;
{ID}                  yylval.string = yytext; return ID;

{PUNCTUATION}         return (int)(*yytext);
{WHITESPACE}
.                     invalid_token();
<<EOF>>               return EOF;

%%
