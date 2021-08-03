%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "latex-to-markdown.h"
%}

%union
{   
    struct ast *a;
    char *string;
};

%token <string> NAME
%token <string> CONTENT
%token NUMBER
// keywords
%token DOCUMENT
%token _BEGIN
%token _END
%token CLASS
%token PACKAGE
%token AUTHOR 
%token TITLE
%token CHAPTER
%token SECTION
%token SUBSECTION
%token PAR
%token BF
%token UNDERLINE
%token IT
%token <string> ITEM
%token ENUMERATE
%token ITEMIZE

%type <a> documentLatex identification settings class package main begin end bodyList chapter section subsection body text textStyle lists numberedList itemList itens

%%

documentLatex: settings identification main {
    // eval($1);
    eval($2);
    eval($3);
}
;

settings: class package {
    $$ = newast(NT_SETTINGS, NULL, $2, NULL, NULL);
} 
;

class: CLASS NAME NAME {
    // $$ = newast(NT_CLASS, NULL, $2, $3, NULL);   /* font-size e estilo de texto ignorados */
    $$ = newast(NT_CLASS, NULL, NULL, NULL, NULL);
}
;

package: /* vazio */ {
    $$ = NULL;
}
| PACKAGE NAME package {
    // $$ = newast(NT_PACKAGE, NULL, $2, $3, NULL); /* pacotes ignorados */
    $$ = newast(NT_PACKAGE, NULL, NULL, $3, NULL);  
}
| PACKAGE NAME NAME package {
    // $$ = newast(NT_PACKAGE, NULL, $2, $3, $4); /* pacotes ignorados */
    $$ = newast(NT_PACKAGE, NULL, NULL, NULL, $4);
}
;

identification: TITLE CONTENT AUTHOR CONTENT {
    $$ = newidentification(NT_IDENTIFICATION, $2, $4);
} 
| TITLE NAME AUTHOR CONTENT {
    $$ = newidentification(NT_IDENTIFICATION, $2, $4);
}
| TITLE CONTENT AUTHOR NAME {
    $$ = newidentification(NT_IDENTIFICATION, $2, $4);
}
| TITLE NAME AUTHOR NAME {
    $$ = newidentification(NT_IDENTIFICATION, $2, $4);
}
| TITLE CONTENT {
    $$ = newidentification(NT_IDENTIFICATION, $2, NULL);
} 
| TITLE NAME {
    $$ = newidentification(NT_IDENTIFICATION, $2, NULL);
}
;

main: begin bodyList end {
    $$ = newast(NT_MAIN, $1, $2, $3, NULL);
}
;

begin: _BEGIN DOCUMENT {
    $$ = newast(NT_BEGIN, NULL, NULL, NULL, NULL);
}
;


end: _END DOCUMENT {
    $$ = newast(NT_END, NULL, NULL, NULL, NULL);
}
;

bodyList: /* vazio */ {
    $$ = NULL;
}
| chapter section subsection bodyList {
    $$ = newast(NT_BODYLIST, $1, $2, $3, $4);
} 
| body {
    $$ = newast(NT_BODYLIST, $1, NULL, NULL, NULL);
}
;

chapter: /* vazio */ {
    $$ = NULL;
}
| CHAPTER CONTENT body chapter {
    $$ = newtextsubdivision(NT_CHAPTER, $2, $3, $4);
}
| CHAPTER NAME body chapter {
    $$ = newtextsubdivision(NT_CHAPTER, $2, $3, $4);
}
| CHAPTER CONTENT {
    $$ = newtextsubdivision(NT_CHAPTER, $2, NULL, NULL);
}
| CHAPTER NAME {
    $$ = newtextsubdivision(NT_CHAPTER, $2, NULL, NULL);
}
;

section: /* vazio */ {
    $$ = NULL;
}
| SECTION CONTENT body section {
    $$ = newtextsubdivision(NT_SECTION, $2, $3, $4);    
}
| SECTION NAME body section {
    $$ = newtextsubdivision(NT_SECTION, $2, $3, $4);    
}
| body {
    $$ = newtextsubdivision(NT_SECTION, NULL, $1, NULL);    
}
;

subsection: /* vazio */ {
    $$ = NULL;
}
| SUBSECTION CONTENT body subsection {
    $$ = newtextsubdivision(NT_SUBSECTION, $2, $3, $4);
} | body {
    $$ = newtextsubdivision(NT_SECTION, NULL, $1, NULL);
} ;

body: text {
    $$ = newast(NT_BODY, $1, NULL, NULL, NULL);
} | text body {
    $$ = newast(NT_BODY, $1, $2, NULL, NULL);
} | textStyle body {
    $$ = newast(NT_BODY, $1, $2, NULL, NULL);
} | lists body {
    $$ = newast(NT_BODY, $1, $2, NULL, NULL);
}
;

text: /* vazio */ {
    $$ = NULL;
}
| NAME text PAR {
    $$ = newtext(NT_TEXT, $1, $2);
}
;

textStyle: BF CONTENT {
    $$ = newtextstyle(NT_TEXT, $2, TS_BOLD);
} | UNDERLINE CONTENT {
    $$ = newtextstyle(NT_TEXT, $2, TS_UNDERLINE);
} | IT CONTENT {
    $$ = newtextstyle(NT_TEXT, $2, TS_ITALIC);
}
;

lists: numberedList {
    $$ = newast(NT_LIST, $1, NULL, NULL, NULL);
} | itemList {
    $$ = newast(NT_LIST, $1, NULL, NULL, NULL);
}
;

numberedList: _BEGIN ENUMERATE itens _END ENUMERATE {
    $$ = newast(NT_NUMBEREDLIST, $3, NULL, NULL, NULL);
}
;

itemList: _BEGIN ITEMIZE itens _END ITEMIZE {
    $$ = newast(NT_ITEMLIST, $3, NULL, NULL, NULL);
}
;

itens: ITEM {
    $$ = newitens(NT_ITENS, $1, NULL);
} | ITEM itens {
    $$ = newitens(NT_ITENS, $1, $2);
}
;
