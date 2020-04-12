%option noyywrap

%s header ingredients methods
%x title

    int title_found = 0;

NAME                                [^\.\n]*
NUMBER                              [0-9]+
DRY                                 g|kg|(pitadas?)(\ de\ )?
LIQUID                              (ml|l|(fios?))(\ de\ )?
MEASURE                             ((colher(es)?(\ de\ (sopa|chá))?)|(xícaras?)|(copos?))(\ de\ )?
BOWL                                ({NUMBER}ª\ )?tigela
DISH                                ({NUMBER}ª\ )?assadeira

%%
    if (!title_found)
        BEGIN(title);

<title>^{NAME}"."/\n				                            {
                                                                    title_found = 1;
                                                                    BEGIN(header);
                                                                    printf("<recipe, \"%s\">\n", yytext);
                                                                }

<header>{
    ^Ingredientes\.		                                        {
                                                                    BEGIN(ingredients);
                                                                    printf("<section_ingredients>\n");
                                                                }
    (.|\n)*/"Ingredientes."       	                            { }
}

<ingredients>{
    ^Pré-aqueça\ o\ forno\ a\ {NUMBER}\ °C\.                    { }
    ^Tempo\ de\ preparo:\ {NUMBER}\ ((horas?)|(minutos?))\.     { }
    ^Modo\ de\ preparo\.                                        { BEGIN(methods); printf("<section_methods>\n"); }
    {NUMBER}                                                    { printf("<value, \"%s\">\n", yytext); }
    {DRY}                                                       { printf("<dry_modifier>\n"); }
    {LIQUID}                                                    { printf("<liquid_modifier>\n"); }
    {MEASURE}                                                   { }
    {NAME}                                                      { printf("<ingredient, \"%s\">\n", yytext); }
}

<methods>{
    Rendimento:\ {NUMBER}(\ (porções|pessoas))?\.               {
                                                                    BEGIN(0);
                                                                    title_found = 0;
                                                                    printf("<serves>\n");
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
    Misture(\ a\ {BOWL})?\ por\ {NUMBER}\ minutos\.             { printf("<stir, \"%s\">\n", yytext); }
    Misture\ (o|a)s?\ {NAME}\ na\ {BOWL}\.                      { printf("<stir_ingredient, \"%s\">\n", yytext); }
    Limpe\ a\ {BOWL}\.                                          { printf("<clean, \"%s\">\n", yytext); }
    Despeje\ o\ conteúdo\ da\ {BOWL}\ na\ {DISH}\.              { printf("<pour, \"%s\">\n", yytext); }
    Deixe\ descansar\.                                          { printf("<rest>"); }
    Sirva\ com\ {NAME}\.                                        { printf("<serve, \"%s\">\n", yytext); }
    Refrigere(\ por\ {NUMBER}\ horas?)?\.                       { printf("<refrigerate, \"%s\">\n", yytext); }
    {NAME}\ (o|a)s?\ {NAME}\ até\ {NAME}\.                      { printf("<verb_until, \"%s\">\n", yytext); }
    {NAME}\ (o|a)s?\ {NAME}\.                                   { printf("<verb, \"%s\">\n", yytext); }
}

<*>[\ \n]                                                       { }
