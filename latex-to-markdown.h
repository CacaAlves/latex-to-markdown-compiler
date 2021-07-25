#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

/* interface com o lexer */

extern int yylineno; /* do lexer */
void yyerror(char *s, ...);