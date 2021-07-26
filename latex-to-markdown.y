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

%%

documentLatex: settings identification {
}
;

settings: class package {
    // package can be empty
} 
;

class: CLASS NAME NAME {
    printf("class\n");
}
;

package: /* empty */ 
| PACKAGE NAME package {
    printf("package\n");
}
| PACKAGE NAME NAME package {
    printf("package\n");
}
;

identification: TITLE CONTENT AUTHOR CONTENT {
    printf("title author\n");
} 
| TITLE NAME AUTHOR CONTENT {
    printf("title author\n");
}
| TITLE CONTENT AUTHOR NAME {
    printf("title author\n");
}
| TITLE NAME AUTHOR NAME {
    printf("title author\n");
}
| TITLE CONTENT {
    printf("title author\n");
} 
| TITLE NAME{
    printf("title author\n");
}
;

main: begin bodyList end {

}
;

begin: _BEGIN'{'DOCUMENT'}' {
    printf("begin\n");
}
;


end: _END'{'DOCUMENT'}' {
    printf("end\n");
}
;

bodyList: /* empty */
| chapter section subsection bodyList {

} 
| body {

}
;

chapter: /* empty */
| CHAPTER NAME body chapter {

} | CHAPTER NAME {

}
;

section: /* empty */
| SECTION NAME body section {

} | body {

}
;

subsection: /* empty */
| SUBSECTION NAME body subsection {

} | body {

} ;

body: text {

} | text body {
    
} | textStyle body {

} | lists body {

}
;

text: PARAGRAPH'{'CONTENT'}' {

}
;

textStyle: BF'{'CONTENT'}' {

} | UNDERLINE'{'CONTENT'}' {

} | IT'{'CONTENT'}' {

}
;

lists: numberedList {

} | itemList {

}
;

numberedList: _BEGIN'{'ENUMERATE'}' {

}
;

itensLNumbered: ITEM'{'CONTENT'}' {

} | ITEM'{'CONTENT'}' itensLNumbered {
    
} | lists {

}
;

itemList: _BEGIN'{'ITEMIZE'}' itensLItens _END'{'ITEMIZE'}' {

}
;

itensLItens: ITEM'{'CONTENT'}' {

} | ITEM'{'CONTENT'}' itensLItens {

} | lists {

}
;




