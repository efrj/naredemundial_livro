<?
/*
Função : Exibe os Detalhes
Desenvolvedor: Cerli Rocha
Data : 20/06/2003
Atualização : 30/06/2003
*/

session_start(); //Inicializa a sessão
include("funcoes.php"); //Inclui o arquivo de funções

//Busca os dados da agenda de acordo com o Código recebido
function editar_agenda($ID)
{
    global $con;
    global $nome, $endereco, $ddd, $fone, $email, $observacoes;
    $valor = false;
    $sql = "SELECT ID, NOME, ENDERECO, DDD, FONE, EMAIL, OBSERVACOES, DATA FROM Agenda WHERE ID = $ID";
    $result = odbc_exec($con, $sql);
    if (!$result) {
        $valor = false;
    } else {
        while (odbc_fetch_row($result)) {
            $nome = odbc_result($result, 2);
            $endereco = odbc_result($result, 3);
            $ddd = odbc_result($result, 4);
            $fone = odbc_result($result, 5);
            $email = odbc_result($result, 6);
            $observacoes = odbc_result($result, 7);
        }
    }
    return $valor;
}

//Corpo principal do script
//Lendo a Sessão
$usuario = trim($_SESSION['USUARIO']);
//Lendo o Código
$id = trim($_GET['ID']);

//Testando se o usuario está logado
if (($usuario != "") && ($usuario != "")) {

    if (empty($con)) { //Testa se existe a conexão
        conecta(BANCO, USUARIO, SENHA);//Conectando ao banco
    }
    //Chama a função que exibirá os detalhes
    editar_agenda($id);
    //Abaixo o HTML
    ?>

    <html>

    <head>
        <title>:: Agenda PHP ::</title>
    </head>

    <body bgcolor="#778899">
        <table border=0 align=center bgcolor=White width="100%">
            <td valign=top>
                <table width="100%" border="0" align="center">
                    <tr>
                        <td bgcolor=white>
                            <table width="100%" border="0" align="center">
                                <tr>
                                    <td align=right colspan=2>.: <b>Inserir Nomes na
                                            Agenda</b> :.</td>
                                </tr>
                                <tr>
                                    <td align=right width="30%"><b>Nome</b>: &nbsp;</td>
                                    <td>

                                                                                <?= $nome ?>

                                    </td>
                                </tr>
                                <tr> </tr>
                                <td align=right width="30%"><b>Endere&ccedil;o</b>:
                                    &nbsp;</td>
                                <td>

                                                                        <?= $endereco ?>

                                </td>
                    </tr>
                    <tr>
                        <td><b>Fone</b>: </td>
                        <td>

                                                        <?= $ddd ?>

                            -

                                                        <?= $fone ?>

                        </td>
                    </tr>
                    <tr>
                        <td><b>Email</b>: </td>
                        <td>

                                                        <?= $email ?>

                        </td>
                    </tr>
                    <tr>
                        <td><b>Observa&ccedil;&otilde;es</b>: </td>
                        <td>

                                                        <?= $observacoes ?>

                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td><a href="#" onClick="self.close()">fechar</a></td>
                    </tr>
                </table>
            </td>
            </tr>
        </table>
        </td>
        </tr>
        </table>
    </body>

    </html>

    <?
} else {
    print "<script>
self.close();
</script>";
}
?>