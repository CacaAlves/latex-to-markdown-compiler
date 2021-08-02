#include "latex-to-markdown.h"

void yyerror(char *s, ...)
{
    va_list ap;
    va_start(ap, s);

    fprintf(stderr, "%d: error: ", yylineno);
    vfprintf(stderr, s, ap);
    fprintf(stderr, "\n");
}

struct ast *newast(enum NodeType nodetype, struct ast *n1, struct ast *n2, struct ast *n3, struct ast *n4)
{
    struct ast *a = malloc(sizeof(struct ast));

    if (!a)
    {
        yyerror("sem espaço");
        exit(0);
    }

    a->nodetype = nodetype;
    a->n1 = n1;
    a->n2 = n2;
    a->n3 = n3;
    a->n4 = n4;

    return a;
}

struct ast *newidentification(enum NodeType nodetype, char *title, char *author)
{
    struct StructIdentification *a = malloc(sizeof(struct StructIdentification));

    if (!a)
    {
        yyerror("sem espaço");
        exit(0);
    }

    a->nodetype = nodetype;
    a->title = title;
    a->author = author;

    return ((struct ast *)a);
}

struct ast *newbody(struct ast *nodetype, char *content, struct ast *n1, struct ast *n2)
{
    struct StructBody *a = malloc(sizeof(struct StructBody));

    if (!a)
    {
        yyerror("sem espaço");
        exit(0);
    }

    a->nodetype = nodetype;
    a->content = content;
    a->n1 = n1;
    a->n2 = n2;

    return ((struct ast *)a);
}

struct ast *newparagraph(struct ast *nodetype, char *content)
{
    struct StructParagraph *a = malloc(sizeof(struct StructParagraph));

    if (!a)
    {
        yyerror("sem espaço");
        exit(0);
    }

    a->nodetype = nodetype;
    a->content = content;

    return ((struct ast *)a);
}

struct ast *newtextstyle(struct ast *nodetype, char *content, enum TextStyle textStyle)
{
    struct StructTextStyle *a = malloc(sizeof(struct StructTextStyle));

    if (!a)
    {
        yyerror("sem espaço");
        exit(0);
    }

    a->nodetype = nodetype;
    a->content = content;
    a->textStyle = textStyle;

    return ((struct ast *)a);
}

struct ast *newItensLNumbered(struct ast *nodetype, char *content, struct ast *next)
{
    struct StructItensLNumbered *a = malloc(sizeof(struct StructItensLNumbered));

    if (!a)
    {
        yyerror("sem espaço");
        exit(0);
    }

    a->nodetype = nodetype;
    a->content = content;
    a->next = next;

    return ((struct ast *)a);
}

struct ast *newItensLItem(struct ast *nodetype, char *content, struct ast *next)
{
    struct StructItensLItem *a = malloc(sizeof(struct StructItensLItem));

    if (!a)
    {
        yyerror("sem espaço");
        exit(0);
    }

    a->nodetype = nodetype;
    a->content = content;
    a->next = next;

    return ((struct ast *)a);
}


void eval(struct ast *a)
{
    // double v;

    if (!a)
    {
        yyerror("erro interno, null eval");
        return;
    }

    switch (a->nodetype)
    {
        case NT_IDENTIFICATION:
            appendoutput("# ");
            appendoutput(((struct StructIdentification *)a)->title);
            appendoutput("\n");

            if (((struct StructIdentification *)a)->author)
            {
                appendoutput("### ");
                appendoutput(((struct StructIdentification *)a)->author);
                appendoutput("\n");
            }

            appendoutput("\n");
            break;
        default:
            printf("erro interno: bad node %c\n", a->nodetype);
    }
    // {
    // /* constante */
    // case 'K':
    //     v = ((struct numval *)a)->number;
    //     break;

    // /* referência de nome */
    // case 'N':
    //     v = (((struct symref *)a)->s)->value;
    //     break;

    // case '=':
    //     v = (((struct symasgn *)a)->s)->value = eval(((struct symasgn *)a)->v);
    //     break;

    // /* expressões */
    // case '+':
    //     v = eval(a->l) + eval(a->r);
    //     break;
    // case '-':
    //     v = eval(a->l) - eval(a->r);
    //     break;
    // case '*':
    //     v = eval(a->l) * eval(a->r);
    //     break;
    // case '/':
    //     v = eval(a->l) / eval(a->r);
    //     break;

    // /* comparações */
    // case '1':
    //     v = (eval(a->l) > eval(a->r) ? 1 : 0);
    //     break;
    // case '2':
    //     v = (eval(a->l) < eval(a->r) ? 1 : 0);
    //     break;
    // case '3':
    //     v = (eval(a->l) != eval(a->r) ? 1 : 0);
    //     break;
    // case '4':
    //     v = (eval(a->l) == eval(a->r) ? 1 : 0);
    //     break;
    // case '5':
    //     v = (eval(a->l) >= eval(a->r) ? 1 : 0);
    //     break;
    // case '6':
    //     v = (eval(a->l) <= eval(a->r) ? 1 : 0);
    //     break;

    // /* controle de fluxo */
    // /* gramática permite expressões vazias */

    // /* if / then / else */
    // case 'I':
    //     if (eval(((struct flow *)a)->cond) != 0) /* verifica condição */
    //     {
    //         if (((struct flow *)a)->tl) /* ramo verdadeiro */
    //         {
    //             v = eval(((struct flow *)a)->tl);
    //         }
    //         else
    //         {
    //             v = 0.0; /* valor default */
    //         }
    //     }
    //     else
    //     {
    //         if (((struct flow *)a)->el) /* ramo falso */
    //         {
    //             v = eval(((struct flow *)a)->el);
    //         }
    //         else
    //         {
    //             v = 0.0; /* valor default */
    //         }
    //     }
    //     break;

    // /* while / do */
    // case 'W':
    //     v = 0.0; /* valor default */

    //     if (((struct flow *)a)->tl) /* testa se lista de comandos não é vazia */
    //     {
    //         while (eval(((struct flow *)a)->cond) != 0) /* avalia a condição */
    //             v = eval(((struct flow *)a)->tl);       /* avalia comandos */
    //     }
    //     break;

    // /* lista de comandos */
    // case 'L':
    //     eval(a->l);
    //     v = eval(a->r);
    //     break;
    // case 'F':
    //     v = callbuiltin((struct fncall *)a);
    //     break;
    // case 'C':
    //     v = calluser((struct ufncall *)a);
    //     break;
    // default:
    //     printf("erro interno: bad node %c\n", a->nodetype);
    // }
    // return v;
}

/* libera uma árvore de AST */
void treefree(struct ast *a)
{
//     switch (a->nodetype)
//     {
//     /* duas subarvores */
//     case '+':
//     case '-':
//     case '*':
//     case '/':
//     case '1':
//     case '2':
//     case '3':
//     case '4':
//     case '5':
//     case '6':
//     case 'L':
//         treefree(a->r);

//     /* uma subarvore*/
//     case 'C':
//     case 'F':
//         treefree(a->l);

//     /* sem subarvore */
//     case 'K':
//     case 'N':
//         // free(a);
//         break;

//     case '=':
//         free(((struct symasgn *)a)->v);
//         break;

//     /* acima de 3 subarvores */
//     case 'I':
//     case 'W':
//         free(((struct flow *)a)->cond);
//         if (((struct flow *)a)->tl)
//             treefree(((struct flow *)a)->tl);
//         if (((struct flow *)a)->el)
//             treefree(((struct flow *)a)->el);
//         break;

//     default:
//         printf("erro interno: free bad node %c\n", a->nodetype);
//     }

//     free(a); /* sempre libera o próprio nó */
}

void copystring(char **dest, char *src)
{
    const int n = strlen(src) - 2;  /* ignoring '{''}' */
    (*dest) = (char *)malloc((sizeof(char) * n) + 1);

    strncpy((*dest), &src[1], n);
    (*dest)[n] = '\0';
}

void clearoutput()
{
    output = fopen(outputfilename, "w");
    fclose(output);
}

void appendoutput(char * str)
{
    fputs(str, output);
}

int main(int argc, char **argv)
{

     if (argc > 1) 
    {
        if (!(yyin = fopen(argv[1], "r")))
        {
            perror(argv[1]);
            return(1);
        }
    }

    int n = strlen(argv[1]); /* filename */
    n += 5;                  /* filename + .out\0 */
    outputfilename = (char *)malloc(sizeof(char) * n);
    strcat(outputfilename, argv[1]);
    strcat(outputfilename, ".out");
    outputfilename[n-1] = '\0';

    printf("%s\n", outputfilename);
    clearoutput();

    output = fopen(outputfilename, "a");

    printf("> ");
    return yyparse();
}