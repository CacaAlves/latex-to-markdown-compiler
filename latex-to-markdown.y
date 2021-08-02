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
%token PARAGRAPH
%token BF
%token UNDERLINE
%token IT
%token ITEM
%token ENUMERATE
%token ITEMIZE

%type <a> documentLatex identification settings class package main begin end bodyList chapter section subsection body text textStyle lists numberedList itensLNumbered itemList itensLItem

%%

documentLatex: settings identification {
    // printf("= %4.4g\n> ", eval($2));    /* em vez de printar, vai ser escrever num arquivo */
    eval($2);
}
;

settings: class package {
    $$ = newast(NT_SETTINGS, NULL, $2, NULL, NULL);
} 
;

class: CLASS NAME NAME {
    $$ = newast(NT_CLASS, NULL, $2, $3, NULL);
}
;

package: /* empty */ {
    $$ = NULL;
}
| PACKAGE NAME package {
    $$ = newast(NT_PACKAGE, NULL, $2, $3, NULL);
}
| PACKAGE NAME NAME package {
    $$ = newast(NT_PACKAGE, NULL, $2, $3, $4);
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
| TITLE NAME{
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

bodyList: /* empty */ {
    $$ = NULL;
}
| chapter section subsection bodyList {
    $$ = newast(NT_BODYLIST, $1, $2, $3, $4);
} 
| body {
    $$ = newast(NT_BODYLIST, $1, NULL, NULL, NULL);
}
;

chapter: /* empty */
| CHAPTER CONTENT body chapter {
    $$ = newast(NT_CHAPTER, NULL, $2, $3, $4,);
} | CHAPTER CONTENT {
    $$ = newast(NT_CHAPTER, NULL, $2, NULL, NULL);
}
;

section: /* empty */ {
    $$ = NULL;
}
| SECTION CONTENT body section {
    $$ = newast(NT_SECTION, NULL, $2, $3, $4);    
} | body {
    $$ = newast(NT_SECTION, NULL, $2, NULL, NULL);    
}
;

subsection: /* empty */ {
    $$ = NULL;
}
| SUBSECTION CONTENT body subsection {
    $$ = newast(NT_SUBSECTION, NULL, $2, $3, $4);
} | body {
    $$ = newast(NT_SUBSECTION, NULL, $2, NULL, NULL);
} ;

body: text {
} | text body {
    $$ = newbody(NT_BODY, $1, $2, NULL);
} | textStyle body {
    $$ = newbody(NT_BODY, NULL, $1, $2);
} | lists body {
    $$ = newbody(NT_BODY, NULL, $1, $2);
}
;

text: PARAGRAPH'{'CONTENT'}' {
    $$ = newparagraph(NT_TEXT, $3);
}
;

textStyle: BF'{'CONTENT'}' {
    $$ = newtextstyle(NT_TEXT, BOLD, $1);
} | UNDERLINE'{'CONTENT'}' {
    $$ = newtextstyle(NT_TEXT, UNDERLINE, $1);
} | IT'{'CONTENT'}' {
    $$ = newtextstyle(NT_TEXT, ITALIC, $1);
}
;

lists: numberedList {
    $$ = newast(NT_LIST, $1, NULL, NULL, NULL);
} | itemList {
    $$ = newast(NT_LIST, $1, NULL, NULL, NULL);
}
;

numberedList: _BEGIN'{'ENUMERATE'}' itensLItem _END'{'ENUMERATE'}' {
    $$ = newast(NT_NUMBEREDLIST, $5, NULL, NULL, NULL);
}
;

itensLNumbered: ITEM'{'CONTENT'}' {

} | ITEM'{'CONTENT'}' itensLNumbered {
    
} | lists {

}
;

itemList: _BEGIN'{'ITEMIZE'}' itensLItem _END'{'ITEMIZE'}' {

}
;

itensLItem: ITEM'{'CONTENT'}' {

} | ITEM'{'CONTENT'}' itensLItem {

} | lists {

}
;




