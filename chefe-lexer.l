%option noyywrap

%x title header ingredients methods

    int title_found = 0;
    int value_found = 0;
    int modifier_found = 0;
    int current_line = 0;

ALPHA                               [a-zA-ZáÁàÀãÃâÂéÉèÈêÊÍíìÌóÓÒòÕõôÔÚúÙù]
NAME                                {ALPHA}[^\.\n]*
NUMBER                              [0-9]+
DRY                                 (\ (g|kg|(pitadas?))\ de\ )
LIQUID                              (\ (ml|l|(fios?))\ de\ )
MEASURE                             (\ ((colher(es)?\ de\ (sopa|chá))?)|(xícaras?)|(copos?)\ de\ )
BOWL                                ({NUMBER}ª\ )?tigela
DISH                                ({NUMBER}ª\ )?assadeira

%%
<INITIAL>^{NAME}\./\n				                            {
                                                                    printf("<recipe, \"%s\">\n", yytext);
                                                                    BEGIN(header);
                                                                }

<header>{
    ^Ingredientes\./\n		                                    {
                                                                    printf("<section_ingredients>\n");
                                                                    value_found = 0;
                                                                    modifier_found = 0;
                                                                    BEGIN(ingredients);
                                                                }
    .                                                           { }
}

<ingredients>{
    ^Pré-aqueça\ o\ forno\ a\ {NUMBER}\ °C\.                    { }
    ^Tempo\ de\ preparo:\ {NUMBER}\ ((horas?)|(minutos?))\.     { }
    ^Modo\ de\ preparo\.                                        { printf("<section_methods>\n"); BEGIN(methods); }
    {NUMBER}                                                    { printf("<ingredient_value, \"%s\">\n", yytext); }

    {DRY}                                                       {
                                                                    if (modifier_found == 0)
                                                                    {
                                                                        modifier_found = 1;
                                                                        printf("<dry_modifier>\n");
                                                                    }
                                                                }

    {LIQUID}                                                    {
                                                                    if (modifier_found == 0)
                                                                    {
                                                                        modifier_found = 1;
                                                                        printf("<liquid_modifier>\n");
                                                                    }
                                                                }

    {MEASURE}                                                   {
                                                                    if (modifier_found == 0)
                                                                    {
                                                                        modifier_found = 1;
                                                                    }
                                                                }

    {NAME}/\n                                                   { printf("<ingredient_name, \"%s\">\n", yytext); }
    
    \n                                                          {
                                                                    value_found = 0;
                                                                    modifier_found = 0;
                                                                    current_line++;
                                                                }
}

<methods>{
    ^Rendimento\:\ {NUMBER}\ ((porç(ão|ões))|(pessoas?))\./\n   {
                                                                    printf("<serves, \"%s\">\n", yytext);
                                                                    BEGIN(INITIAL);
                                                                }
    Retire\ (o|a)s?\ {NAME}\ do\ refrigerador\.                 { printf("<take, \"%s\">\n", yytext); }
    Coloque\ (o|a)s?\ {NAME}\ na\ {BOWL}\.                      { printf("<put, \"%s\">\n", yytext); }
    Sove\ (o|a)s?\ {NAME}\ na\ {BOWL}\.                         { printf("<fold, \"%s\">\n", yytext); }
    Adicione\ os\ ingredientes\ sólidos(\ na\ {BOWL})?\.        { printf("<add_dry, \"%s\">\n", yytext); }
    Adicione\ (o|a)s?\ {NAME}(\ na\ {BOWL})?\.                  { printf("<add, \"%s\">\n", yytext); }
    Remova\ (o|a)s?\ {NAME}(\ da\ {BOWL})?\.                    { printf("<remove, \"%s\">\n", yytext); }
    Combine\ (o|a)s?\ {NAME}(\ na\ {BOWL})?\.                   { printf("<combine, \"%s\">\n", yytext); }
    Divida\ (o|a)s?\ {NAME}(\ na\ {BOWL})?\.                    { printf("<divide, \"%s\">\n", yytext); }
    Liquidifique\ o\ conteúdo\ da\ {BOWL}\.                     { printf("<liquefy_bowl, \"%s\">\n", yytext); }
    Liquidifique\ (o|a)s?\ {NAME}\.                             { printf("<liquefy, \"%s\">\n", yytext); }
    Misture\ bem(\ a\ {BOWL})?\.                                { printf("<mix_well, \"%s\">\n", yytext); }
    Misture(\ a\ {BOWL})?\ por\ {NUMBER}\ minutos?\.            { printf("<stir, \"%s\">\n", yytext); }
    Misture\ (o|a)s?\ {NAME}\ na\ {BOWL}\.                      { printf("<stir_ingredient, \"%s\">\n", yytext); }
    Limpe\ a\ {BOWL}\.                                          { printf("<clean, \"%s\">\n", yytext); }
    Despeje\ o\ conteúdo\ da\ {BOWL}\ na\ {DISH}\.              { printf("<pour, \"%s\">\n", yytext); }
    Deixe\ descansar\.                                          { printf("<rest>"); }
    Sirva\ com\ {NAME}\.                                        { printf("<serve, \"%s\">\n", yytext); }
    Refrigere(\ por\ {NUMBER}\ horas?)?\.                       { printf("<refrigerate, \"%s\">\n", yytext); }
    {NAME}\ (o|a)s?\ {NAME}\ até(\ que)?\ {NAME}\.              |
    {NAME}\ até(\ que)?\ (o|a)s?\ {NAME}\.                      { printf("<verb_until, \"%s\">\n", yytext); }
    {NAME}\ (o|a)s?\ {NAME}\.                                   { printf("<verb, \"%s\">\n", yytext); }
    ^{NAME}\./\n                                                {
                                                                    BEGIN(header);
                                                                    title_found = 1;
                                                                    printf("<recipe, \"%s\">\n", yytext);
                                                                }
}

<*>[ ]                                                          { }
<*>\n                                                           { current_line++; }
<*>.                                                            { printf("Unexpected token '%s' at line %d", yytext, current_line); }
