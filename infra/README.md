# Infraestrutura da agenda PHP / ASP / JSP

Os três aplicativos usam o mesmo `database/agenda.mdb`. Os arquivos em `php/`,
`asp/` e `jsp/` são as versões adaptadas. A transcrição fiel do livro foi preservada
em `originais/`, inclusive com os erros presentes nas listagens.

## Executar

Na raiz do projeto:

```sh
cd infra
docker compose up -d --build
```

| Aplicação | Endereço | Runtime |
| --- | --- | --- |
| PHP | http://localhost:8081/index.php | PHP 4.4.9 CGI + Apache 2.4, Debian |
| ASP | http://localhost:8082/index.asp | AxonASP Server 2.2.3, Alpine |
| JSP | http://localhost:8083/index.jsp | Tomcat embarcado 9.0.121 / JSP 2.3 + OpenJDK 17, Alpine |

Login: **agenda**. Senha: **agenda**.

O primeiro build baixa imagens e compila o PHP 4. No Mac Apple Silicon, o PHP usa
`linux/amd64` sob emulação; ASP e JSP usam a arquitetura nativa. As portas estão
publicadas somente em `127.0.0.1`, para uso local com esses runtimes históricos.

```sh
docker compose logs -f          # acompanhar os serviços
docker compose stop            # parar sem remover containers
docker compose down            # remover containers e rede; preserva o MDB local
```

## Access no Linux e no macOS

A proposta do PDF de criar o Access usando Java aplica-se também ao Linux.
UCanAccess é JDBC e usa Jackcess para manipular o arquivo sem o Microsoft Office.
Instalar `mdbtools` ou `unixODBC` não cria, por si só, um MDB com CRUD completo.
MDBTools é útil para leitura/exportação e consultas limitadas; não foi escolhido
como motor de escrita da agenda.

A configuração ODBC de macOS do PDF usa uma biblioteca `.dylib` e caminhos do
Homebrew. No Linux os caminhos e a biblioteca `.so` são diferentes. Mesmo com a
configuração correta, isso não resolve as limitações de escrita nem acrescenta
ODBC à implementação de ADODB do AxonASP.

Nesta infraestrutura **não há DSN ODBC AGENDA**. As conexões foram substituídas:

- JSP acessa UCanAccess 5.1.7 diretamente, usando JDBC.
- PHP 4 usa uma chamada HTTP interna e o parser XML nativo.
- ASP usa `MSXML2.ServerXMLHTTP` e `MSXML2.DOMDocument`, disponíveis no AxonASP.
- O serviço Java, dentro do container JSP, atende a API interna na porta 8081.
  Essa porta do container JSP **não é publicada no host**. A porta 8081 do host
  pertence ao Apache/PHP, não à API.

Apenas o processo Java abre o MDB. Uma única conexão, operações sincronizadas,
`openExclusive=true` e um lock de processo evitam que os três runtimes abram
cópias independentes do arquivo simultaneamente. PHP e ASP dependem do serviço
JSP saudável; ao parar JSP, o acesso ao banco das outras versões também para.
Não escale o serviço JSP para várias réplicas usando o mesmo arquivo.

## Criação e persistência do banco

O banco entregue é Access 2000 / Jet 4 (`V2000`), com a tabela `Agenda`:

| Campo | Tipo |
| --- | --- |
| ID | COUNTER, chave primária, autonumeração |
| NOME | VARCHAR(100) |
| ENDERECO | VARCHAR(100) |
| DDD | VARCHAR(5) |
| FONE | VARCHAR(20) |
| EMAIL | VARCHAR(100) |
| OBSERVACOES | VARCHAR(255) |
| DATA | DATETIME |

A coluna DATA é mantida no esquema, sem preenchimento automático, como nas
inserções do livro. A geração está implementada em `java/src/main/java/agenda/Store.java`.
O arquivo é criado somente se não existir. Um banco existente é preservado e seu
esquema é conferido; um esquema incompatível provoca falha explícita.

Para gerar o banco em um checkout novo, sem iniciar os servidores HTTP:

```sh
docker compose build jsp
docker compose run --rm --no-deps jsp --init
```

`docker compose up` também inicializa o banco ausente automaticamente. Não execute
`--init` enquanto o serviço JSP estiver usando o mesmo arquivo. Para copiar o MDB
ou abri-lo em outro programa, pare o serviço JSP primeiro.

A pasta inteira é montada como volume, permitindo os arquivos auxiliares e locks.
O `.gitignore` exclui `*.mdb`, `*.accdb`, seus locks e o conteúdo de
`infra/database/`, exceto `.gitkeep`. O `.dockerignore` também impede a inclusão do
banco no contexto de build. Um novo clone recebe a receita de criação, não os dados.

## Escolhas de imagem e alterações

- A imagem `nouphet/docker-php4` do PDF é PHP 4.4.0, mas o Docker atual rejeita seu
  manifest schema 1. Em vez de exigir downgrade do Docker, o Dockerfile compila
  PHP 4.4.9 do arquivo oficial do PHP Museum, com SHA-256 verificado. Compila apenas
  o CGI e os recursos necessários. `-fcommon` e os arquivos `config.guess/sub`
  atuais permitem usar o compilador do Debian.
- O PDF do AxonASP mostra tags com prefixo `v`, mas a tag efetivamente disponível
  no registro e utilizada aqui é `2.2.3`. Nenhum código do runtime AxonASP foi alterado.
- A etapa Maven compila Java em uma imagem separada. A imagem final JSP usa
  Alpine 3.23, somente JRE headless e os JARs necessários; Maven, JDK e compiladores
  nativos não vão para ela. A compilação das JSP usa Jasper/ECJ.
- O Tomcat moderno executa a versão **adaptada**, não reproduz exatamente o ambiente
  JSP 1.x inferido do livro. A ponte `sun.jdbc.odbc.JdbcOdbcDriver` foi substituída
  por UCanAccess.
- As páginas mantêm os nomes dos arquivos, campos, credenciais e operações da
  agenda. Código repetido foi centralizado em `funcoes.php`, `funcoes.asp` e nas
  classes Java usadas pelas JSP. O formulário de login JSP foi corrigido.
- As consultas usam parâmetros JDBC e os valores exibidos são escapados como HTML.
  A exclusão usa uma confirmação e POST. A busca usa GET e pesquisa nome, email
  ou telefone. Detalhes são exibidos como página com link de retorno.

## Fontes verificadas

- [UCanAccess: criação de arquivos, opções JDBC e lock](https://spannm.github.io/ucanaccess/20-getting-started.html)
- [MDBTools: escopo e driver ODBC](https://github.com/mdbtools/mdbtools)
- [AxonASP: código ADODB e tratamento de Access no Windows](https://github.com/guimaraeslucas/axonasp/blob/v2.3.21/axonvm/lib_adodb.go)
- [AxonASP Server: Dockerfile da versão 2.2.3](https://github.com/guimaraeslucas/axonasp/blob/v2.2.3/Dockerfile)
- [Dockerfile original nouphet/docker-php4](https://github.com/nouphet/docker-php4/blob/master/Dockerfile)
- [PHP Museum: fontes históricas](https://museum.php.net/php4/)
- [Tomcat: versões de JSP e Servlet](https://tomcat.apache.org/whichversion.html)
