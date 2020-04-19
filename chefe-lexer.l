%option noyywrap yylineno

%x title header ingredients methods

    int title_found = 0;
    int value_found = 0;
    int modifier_found = 0;

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
                                                                    printf("<\033[0;36mrecipe\033[0m, \033[0;33m\"%s\"\033[0m>\n", yytext);
                                                                    BEGIN(header);
                                                                }

<header>{
    ^Ingredientes\./\n		                                    {
                                                                    printf("<\033[0;36msection_ingredients\033[0m>\n");
                                                                    value_found = 0;
                                                                    modifier_found = 0;
                                                                    BEGIN(ingredients);
                                                                }
    .                                                           { }
}

<ingredients>{
    ^Pré-aqueça\ o\ forno\ a\ {NUMBER}\ °C\.                    { }
    ^Tempo\ de\ preparo:\ {NUMBER}\ ((horas?)|(minutos?))\.     { }
    ^Modo\ de\ preparo\.                                        { printf("<\033[0;36msection_methods\033[0m>\n"); BEGIN(methods); }
    {NUMBER}                                                    { printf("<\033[0;36mingredient_value\033[0m, \033[0;32m%s\033[0m>\n", yytext); }

    {DRY}                                                       {
                                                                    if (modifier_found == 0)
                                                                    {
                                                                        modifier_found = 1;
                                                                        printf("<\033[0;36mdry_modifier\033[0m>\n");
                                                                    }
                                                                }

    {LIQUID}                                                    {
                                                                    if (modifier_found == 0)
                                                                    {
                                                                        modifier_found = 1;
                                                                        printf("<\033[0;36mliquid_modifier\033[0m>\n");
                                                                    }
                                                                }

    {MEASURE}                                                   {
                                                                    if (modifier_found == 0)
                                                                    {
                                                                        modifier_found = 1;
                                                                    }
                                                                }

    {NAME}/\n                                                   { printf("<\033[0;36mingredient_name\033[0m, \033[0;33m\"%s\"\033[0m>\n", yytext); }
    
    \n                                                          {
                                                                    value_found = 0;
                                                                    modifier_found = 0;
                                                                }
}

<methods>{
    ^Rendimento\:\ {NUMBER}\ ((porç(ão|ões))|(pessoas?))\./\n   {
                                                                    printf("<\033[0;36mserves\033[0m, \033[0;33m\"%s\"\033[0m>\n", yytext);
                                                                    BEGIN(INITIAL);
                                                                }
    Retire\ (o|a)s?\ {NAME}\ do\ refrigerador\.                 { printf("<\033[0;36mtake\033[0m, \033[0;33m\"%s\"\033[0m>\n", yytext); }
    Coloque\ (o|a)s?\ {NAME}\ na\ {BOWL}\.                      { printf("<\033[0;36mput\033[0m, \033[0;33m\"%s\"\033[0m>\n", yytext); }
    Sove\ (o|a)s?\ {NAME}\ na\ {BOWL}\.                         { printf("<\033[0;36mfold\033[0m, \033[0;33m\"%s\"\033[0m>\n", yytext); }
    Adicione\ os\ ingredientes\ sólidos(\ na\ {BOWL})?\.        { printf("<\033[0;36madd_dry\033[0m, \033[0;33m\"%s\"\033[0m>\n", yytext); }
    Adicione\ (o|a)s?\ {NAME}(\ na\ {BOWL})?\.                  { printf("<\033[0;36madd\033[0m, \033[0;33m\"%s\"\033[0m>\n", yytext); }
    Remova\ (o|a)s?\ {NAME}(\ da\ {BOWL})?\.                    { printf("<\033[0;36mremove\033[0m, \033[0;33m\"%s\"\033[0m>\n", yytext); }
    Combine\ (o|a)s?\ {NAME}(\ na\ {BOWL})?\.                   { printf("<\033[0;36mcombine\033[0m, \033[0;33m\"%s\"\033[0m>\n", yytext); }
    Divida\ (o|a)s?\ {NAME}(\ na\ {BOWL})?\.                    { printf("<\033[0;36mdivide\033[0m, \033[0;33m\"%s\"\033[0m>\n", yytext); }
    Liquidifique\ o\ conteúdo\ da\ {BOWL}\.                     { printf("<\033[0;36mliquefy_bowl\033[0m, \033[0;33m\"%s\"\033[0m>\n", yytext); }
    Liquidifique\ (o|a)s?\ {NAME}\.                             { printf("<\033[0;36mliquefy\033[0m, \033[0;33m\"%s\"\033[0m>\n", yytext); }
    Misture\ bem(\ a\ {BOWL})?\.                                { printf("<\033[0;36mmix_well\033[0m, \033[0;33m\"%s\"\033[0m>\n", yytext); }
    Misture(\ a\ {BOWL})?\ por\ {NUMBER}\ minutos?\.            { printf("<\033[0;36mstir\033[0m, \033[0;33m\"%s\"\033[0m>\n", yytext); }
    Misture\ (o|a)s?\ {NAME}\ na\ {BOWL}\.                      { printf("<\033[0;36mstir_ingredient\033[0m, \033[0;33m\"%s\"\033[0m>\n", yytext); }
    Limpe\ a\ {BOWL}\.                                          { printf("<\033[0;36mclean\033[0m, \033[0;33m\"%s\"\033[0m>\n", yytext); }
    Despeje\ o\ conteúdo\ da\ {BOWL}\ na\ {DISH}\.              { printf("<\033[0;36mpour\033[0m, \033[0;33m\"%s\"\033[0m>\n", yytext); }
    Deixe\ descansar\.                                          { printf("<\033[0;36mrest\033[0m>\n"); }
    Sirva\ com\ {NAME}\.                                        { printf("<\033[0;36mserve\033[0m, \033[0;33m\"%s\"\033[0m>\n", yytext); }
    Refrigere(\ por\ {NUMBER}\ horas?)?\.                       { printf("<\033[0;36mrefrigerate\033[0m, \033[0;33m\"%s\"\033[0m>\n", yytext); }
    {NAME}\ (o|a)s?\ {NAME}\ até(\ que)?\ {NAME}\.              |
    {NAME}\ até(\ que)?\ (o|a)s?\ {NAME}\.                      { printf("<\033[0;36mverb_until\033[0m, \033[0;33m\"%s\"\033[0m>\n", yytext); }
    {NAME}\ (o|a)s?\ {NAME}\.                                   { printf("<\033[0;36mverb\033[0m, \033[0;33m\"%s\"\033[0m>\n", yytext); }
    ^{NAME}\./\n                                                {
                                                                    BEGIN(header);
                                                                    title_found = 1;
                                                                    printf("<\033[0;36mrecipe\033[0m, \033[0;33m\"%s\"\033[0m>\n", yytext);
                                                                }
}

<*>[ ]|\n                                                       { }
<*>.                                                            { fprintf(stderr, "\033[0;31mUnexpected token '%s' at line %d\n\033[0m", yytext, yylineno); }

%%

int main(int argc, const char *argv[])
{
    while (yylex())
        continue;

    return 0;
}
