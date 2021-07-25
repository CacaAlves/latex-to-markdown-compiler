%option noyywrap nodefault yylineno
%{
    #include "latex-to-markdown.h"    
    #include "latex-to-markdown.tab.h"    
%}

LETTER [a-zA-Z]
WORD [a-zA-Z]+
DIGIT [0-9]
NUMBER [0-9]+
SPACE " " 

%%

"%".* // comentários são ignorados

\\begin {
    return _BEGIN;
}

\\end {
    return _END;
}

\\document {
    return DOCUMENT;
}

\\documentclass {
    return CLASS;
}

\\usepackage {
    return PACKAGE;
}

\\title {
    return TITLE;
}

\\author {
    return AUTHOR;
}

\\chapter {
    return CHAPTER;
}

\\section {
    return SECTION;
}

\\subsection {
    return SUBSECTION;
}

\\paragraph {
    return PARAGRAPH;
}

\\bf {
    return BF;
}

\\underline {
    return UNDERLINE;
}

\\it {
    return IT;
}

\\item {
    return ITEM;
}

\\enumerate {
    return ENUMERATE;
}

\\itemize {
    return ITEMIZE;
}

"<" |
">" |
"\\" |
"," |
"[" |
"]" |
"{" |
"}" {
    return yytext[0];
}

[a-zA-Z0-9]* {
    return WORDNUMBER;
}

{WORD} {
    return NAME;
}

{NUMBER} {
    return NUMBER;
}

[{WORD}*{NUMBER}*{SPACE}*] {
    return CONTENT;
}

\t|\n|{SPACE} {
    /* Ignora o espaço em branco */
}
. {
    yyerror("Caracter não reconhecido %c\n", *yytext);
}

%%