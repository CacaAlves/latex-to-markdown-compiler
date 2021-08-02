#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

/* interface com o lexer */

extern int yylineno; /* do lexer */
extern FILE *yyin;   /* do lexer */
void yyerror(char *s, ...);

char *outputfilename;
FILE *output;

enum NodeType
{
    NT_DOCUMENT,
    NT_SETTINGS,
    NT_CLASS,
    NT_PACKAGE,
    NT_IDENTIFICATION,
    NT_MAIN,
    NT_BEGIN,
    NT_END,
    NT_BODYLIST,
    NT_CHAPTER,
    NT_SUBCHAPTER,
    NT_SECTION,
    NT_BODY,
    NT_PARAGRAPH,
    NT_TEXTSTYLE,
    NT_LIST,
    NT_NUMBEREDLIST,
    NT_ITENSLNUMBERED,
    NT_ITEMLIST,
    NT_ITENSLITENS
};

enum TextStyle
{
    BOLD,
    ITALIC,
    UNDERLINE
};

struct ast  /* abstractic syntactic list */
{
    enum NodeType nodetype;
    struct ast *n1;
    struct ast *n2;
    struct ast *n3;
    struct ast *n4;
};

struct StructIdentification
{
    enum NodeType nodetype;
    char *title;
    char *author;
};

struct StructBody
{
    enum NodeType nodetype;
    char *content;
    struct ast *n1;
    struct ast *n2;
};

struct StructParagraph
{
    enum NodeType nodetype;
    char *content;
};

struct StructTextStyle
{
    enum NodeType nodetype;
    char *content;
    enum TextStyle textStyle;
};

struct StructItensLNumbered
{
    enum NodeType nodetype;
    char *content;
    struct ast *next;
};

struct StructItensLItem
{
    enum NodeType nodetype;
    char *content;
    struct ast *next;
};

/* construção de uma ast */
struct ast *newast(enum NodeType nodetype, struct ast *n1, struct ast *n2, struct ast *n3, struct ast *n4);
struct ast *newidentification(enum NodeType nodetype, char *n1, char *n2);
struct ast *newbody(struct ast *nodetype, char *content, struct ast *n1, struct ast *n2);
struct ast *newparagraph(struct ast *nodetype, char *content);
struct ast *newtextstyle(struct ast *nodetype, char *content, enum TextStyle textStyle);
struct ast *newItensLNumbered(struct ast *nodetype, char *content, struct ast *next);
struct ast *newItensLItem(struct ast *nodetype, char *content, struct ast *next);


/* avaliação de uma AST */
void eval(struct ast *);

/* deletar e liberar uma AST */
void treefree(struct ast *);

/* cria uma nova string e copia */
void copystring(char **dest, char *src);

/* limpa o arquivo da saída do programa */
void clearoutput();

/* acrescenta uma string na saída do programa */
void appendoutput(char * str);