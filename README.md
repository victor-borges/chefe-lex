# Chefe - Analisador léxico

Para consultar as definições da linguagem, [clique aqui](https://github.com/victor-borges/chefe).

Este projeto foi criado como trabalho da matéria de compiladores.

## Ferramenta utilizada

A fim de manter o desenvolvimento do analisador léxico focado na linguagem a ser analisada, foi utilizada uma ferramenta de criação de analisadores léxicos bem conhecida, o [flex](https://github.com/westes/flex/).

## Mão na massa

Baixe e instale o `flex` e um compilador de `C` (exemplo abaixo utiliza o [gcc](https://gcc.gnu.org/)):

```shell
sudo apt-get update && sudo apt-get install flex gcc
```

Com as dependências instaladas, execute o flex (cria o arquivo `lex.yy.c`):

```shell
flex chefe-lexer.l
```

Compile o arquivo `lex.yy.c` com a _flag_ `-lfl` para _linkar_ com a biblioteca do `flex` (cria o arquivo executável `a.out`):

```shell
gcc lex.yy.c -lfl
```

Execute o arquivo `a.out`:

```shell
./a.out
```

A partir desse momento, qualquer _input_ para o terminal está sendo passado para o analisador léxico. Para finalizar a execução, digite o caractere `EOF` (`Ctrl+D`, ou `Ctrl+Z` no Windows).

Por possuir arquivos fontes relativamente grandes, é interessante redirecionar o `STDIN` diretamente para um arquivo fonte:

```shell
./a.out < ../chefe/receitas/bolo-de-ola-mundo-com-cobertura-de-chocolate.chefe
```
