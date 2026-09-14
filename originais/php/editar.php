<?
/*
Função       : Abre a Agenda para edição
Desenvolvedor: Cerli Rocha
Data         : 20/06/2003
Atualização : 30/06/2003
*/

session_start(); //Inicializa a sessão
include("funcoes.php"); //Inclui o arquivo de funções

//Função que abre a agenda de acordo com o código recebido
function editar_agenda( $ID ) {
         global $con;
         global $nome, $endereco, $ddd, $fone, $email, $observacoes;
         $valor = false;
         $sql     = "SELECT ID, NOME, ENDERECO, DDD, FONE, EMAIL, OBSERVACOES,
DATA FROM Agenda WHERE ID = $ID";
         $result = odbc_exec( $con, $sql );
         if (!$result) {
              $valor = false;
              } else {
                while( odbc_fetch_row( $result ) ) {
                        $nome        = odbc_result( $result, 2 );
                        $endereco    = odbc_result( $result, 3 );
                        $ddd         = odbc_result( $result, 4 );
                        $fone        = odbc_result( $result, 5 );
                         $email       = odbc_result( $result, 6 );
                         $observacoes = odbc_result( $result, 7 );
                }
         }
         return $valor;
}



//Corpo principal do script
$usuario = trim($_SESSION['USUARIO']); //Recebe dados da sessão
$id      = trim($_GET['ID']);

//testa se o usuario está logado
if ( ( $usuario != "" )&&( $usuario != "" ) ) {

        if ( !$con ) { //Testa se existe conexão ao banco
              conecta(BANCO,USUARIO,SENHA);//Conectando ao banco
        }

         //Chama a função que abre os dados da agenda
         editar_agenda($id);
//Abaixo o HTML
?>
<html>
<head>
      <title>:: Agenda PHP ::</title>

</head>
<body bgcolor="#778899" >
<table border=0 align=center bgcolor=White width="700">
      <tr>
            <td valign=top width="100%" align=center>
<?
//Inclui o Menu
include("menu.html");
?>
            </td></tr>

    <td valign=top>
      <form name="form1" action="atualizar_agenda.php" method=post>
        <table width="100%" border="0" align="center">
          <tr>
            <td bgcolor=white> <table width="100%" border="0" align="center">
                <tr>
                  <td align=right colspan=2>.: <b>Inserir Nomes
                     na Agenda</b> :.</td>
                </tr>
                <tr>
                  <td align=right width="30%"><b>Nome</b>: &nbsp;</td>
                  <td><input name="NOME" type=text id="NOME" value="<?=$nome?>"
size=30 maxlength="50"></td>
                </tr>
                <tr> </tr>
                  <td align=right width="30%"><b>Endere&ccedil;o</b>:
                     &nbsp;</td>
                <td><input name="ENDERECO" type=text id="ENDERECO"
value="<?=$endereco?>" size=30 maxlength="100"></td>
                </tr>
                <tr>
                  <td><b>Fone</b>: </td>
                  <td><input name="DDD" type=text id="DDD" value="<?=$ddd?>"
size=3 maxlength="3">
                     -
                     <input name="FONE" type=text id="FONE" value="<?=$fone?>"
size=7 maxlength="10"></td>
                </tr>
                <tr>
                  <td><b>Email</b>: </td>

                    <td><input name="EMAIL" type=text id="EMAIL"
value="<?=$email?>" size=30 maxlength="50"></td>
                  </tr>
                  <tr>
                    <td><b>Observa&ccedil;&otilde;es</b>: </td>
                    <td><textarea name="OBSERVACOES" cols="22" rows="5"
id="OBSERVACOES"><?=$observacoes?></textarea></td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                    <td>
                               <input type="hidden" name="ID" value="<?=$id?>">
                                 <input type=submit name=submit value="Gravar
&gt;&gt;">
                       <input type=reset name=submit2 value="Limpar &gt;&gt;"></td>
                  </tr>
                </table></td>
            </tr>
         </table>
       </form></td>
       </tr>
</table>
</body>
</html>
<?
   } else {
     header("location: index.php"); //Redireciona para tela inicial
}
?>
