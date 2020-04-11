%{
#include "chefe-scanner.h"
%}

number								[0-9]+

%Start HEADER INGREDIENTS

%%
^(.*)"."\n								{ BEGIN HEADER; return RECIPE_TITLE; }
<HEADER>[.\n]*)/("Ingredientes."\n)		;
"Ingredientes."							{ BEGIN INGREDIENTS; return SECTION_INGREDIENTS; }
.										;
%%

int yywrap(void)
{
	return 1;
}
