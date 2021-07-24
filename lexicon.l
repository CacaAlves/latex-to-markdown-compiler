%option noyywrap nodefault yylineno
%{
    #include "functions.h"    
    #include "functions.tab.h"    
%}

%%

"%".* {
    printf("comentários são ignorados\n");
}

%%