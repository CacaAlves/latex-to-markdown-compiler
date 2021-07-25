%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "latex-to-markdown.h"
%}

%token NAME
%token NUMBER
// keywords
%token DOCUMENT
%token _BEGIN
%token _END
%token CLASS
%token PACKAGE
%token AUTHOR
%token TITLE
%token CONTENT
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
%token WORDNUMBER

%%

documentLatex: settings {
}
;

settings: class {
    // package can be empty
} 
;

class: CLASS'['WORDNUMBER']''{'WORDNUMBER'}' {
    printf("aaa\n");
}
;

// package: /* empty */ 
// | PACKAGE'['NAME']''{'NAME'}' package {

// }
// ;

// identification: TITLE'{'NAME'}' AUTHOR'{'NAME'}' {
// } | TITLE'{'NAME'}' {

// } 
// ;

// main: begin bodyList end {

// }
// ;

// begin: _BEGIN'{'DOCUMENT'}' {
//     printf(">");
// }
// ;


// end: _END'{'DOCUMENT'}' {
// }
// ;

// bodyList: chapter section subsection bodyList {

// } 
// | body {

// }
// ;

// chapter: CHAPTER'{'NAME'}' body chapter {

// } | CHAPTER'{'NAME'}' {

// }
// ;

// section: SECTION'{'NAME'}' body section {

// } | body {

// }
// ;

// subsection: SUBSECTION'{'NAME'}' body subsection {

// } | body {

// } ;

// body: text {

// } | text body {
    
// } | textStyle body {

// } | lists body {

// }
// ;

// text: PARAGRAPH'{'CONTENT'}' {

// }
// ;

// textStyle: BF'{'CONTENT'}' {

// } | UNDERLINE'{'CONTENT'}' {

// } | IT'{'CONTENT'}' {

// }
// ;

// lists: numberedList {

// } | itemList {

// }
// ;

// numberedList: _BEGIN'{'ENUMERATE'}' {

// }
// ;

// itensLNumbered: ITEM'{'CONTENT'}' {

// } | ITEM'{'CONTENT'}' itensLNumbered {
    
// } | lists {

// }
// ;

// itemList: _BEGIN'{'ITEMIZE'}' itensLItens _END'{'ITEMIZE'}' {

// }
// ;

// itensLItens: ITEM'{'CONTENT'}' {

// } | ITEM'{'CONTENT'}' itensLItens {

// } | lists {

// }
// ;




