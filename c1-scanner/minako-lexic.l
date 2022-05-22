%option yylineno noyywrap nounput noinput nodefault

%{
#include "minako.h"
#include <stdio.h>
#include <stdlib.h>
%}

%s st
%%

			/* comment in C multi line */
"/*"((("*"[^/])?)|[^*])*"*/" 

			/* comment in C++ single line */
"//".*					



		/*	reserved keywords */
bool                return KW_BOOLEAN;
do                  return KW_DO;
else                return KW_ELSE;
float               return KW_FLOAT;
for                 return KW_FOR;
if                  return KW_IF;
int                 return KW_INT;
printf              return KW_PRINTF;
return              return KW_RETURN;
void                return KW_VOID;
while               return KW_WHILE;

			/* logical */						
&&						return AND;
\|\|					return OR;

			/* relational */						
==						return EQ;
!=						return NEQ;
\>=						return GEQ;
\<=						return LEQ; 
\> 						return GRT;
\< 						return LSS;

             /* variales */

[0-9]+              												 	{ yylval.intValue = atoi(yytext); return CONST_INT;}
[0-9]+"."[0-9]+|"."[0-9]+([eE]([-+])?[0-9]+)?|[0-9]+[eE]([-+])?[0-9]+   { yylval.floatValue = atof(yytext); return CONST_FLOAT;}
true																	{ yylval.intValue = 1; return CONST_BOOLEAN;}
false 																	{ yylval.intValue = 0; return CONST_BOOLEAN;}
\"																		{BEGIN(st);}
<st>[^\n\"]*/\"  														{ yylval.string = yytext; BEGIN(INITIAL);return CONST_STRING;}
([a-zA-Z])+([0-9]|[a-zA-Z])*     										{ yylval.string = yytext; return ID;}


			/* arithmetic */
\+						return 43;
- 						return 45;
\* 						return 42;
\/ 						return 47;
=                       return 61;
					

			/* punctuators */
\(						return 40;
\)						return 41;
\{						return 123;
\}						return 125;
,						return 44;
;						return 59;


		/* skip new lines and blank spaces*/
[ \t\n]	
		/* skip carriage return*/
\r
	
	/* everything not defined before considered an error and will end the program*/
.		 {fprintf(stderr, "Nicht valides Zeichen.\n"); exit(EXIT_FAILURE);}
				

		/* end of file reached*/
<<EOF>>					return EOF;
%%
