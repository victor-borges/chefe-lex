%{
#include "chefe-lexer.h"
%}

%s header ingredients
%x title

    int title_found = 0;

%%
    if (!title_found)
        BEGIN(title);

<title>^(.*)\. 							{ title_found = 1; BEGIN(header); printf("<recipe_title, \"%s\">\n", yytext); }
<header>Ingredientes\.			        { BEGIN(ingredients); printf("<section_ingredients>\n"); }
<header>[.\n]*/Ingredientes\.     		;
<ingredients>
%%
