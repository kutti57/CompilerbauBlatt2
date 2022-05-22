%option yylineno noyywrap nounput noinput nodefault

%{
#include "urlscanner.h"
#include <stdio.h>
#include <stdlib.h>
%}

%s atag
%s text
%s wichtigertext

%%       
            /* return URL if URL is in <a */
"<a href"                       {BEGIN(atag);}             
<atag>http:[^\"]*               { yylval = yytext; BEGIN(text); return TOKEN_URL ;} 

            /* read non important text after URL and befor TEXT */
            
<text>[^\>]*\>                  {BEGIN(wichtigertext);}

            /* return TEXT if URL is in line */
            
<wichtigertext>[^\<\a]*          {yylval = yytext; BEGIN(atag);return TOKEN_TEXT;}


		/* skip new lines and blank spaces*/
[ \t\n]	
		/* skip carriage return*/
\r
	
	/* everything not defined before considered an error and will end the program*/
.		 //{fprintf(stderr, "Nicht valides Zeichen.\n"); exit(EXIT_FAILURE);}
				

		/* end of file reached*/
<<EOF>>					return EOF;
%%
