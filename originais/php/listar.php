<?
/*
Função : Lista os nomes cadastrados na agenda
Desenvolvedor : Cerli Rocha
Data : 30/05/2003
Atualização: 30/06/2003
*/

session_start(); //Inicializa a sessão
include("funcoes.php"); //Inclui o arquivo de funções

//Lista os nomes da agenda
function listar_agenda() {
         global $con;
         $valor = "";
         $sql     = "SELECT ID, NOME, ENDERECO, DDD, FONE, EMAIL, OBSERVACOES,
DATA FROM Agenda";
         $result = odbc_exec( $con, $sql );
         if (!$result) {
              $valor = 0;
              } else {
                while( odbc_fetch_row( $result ) ) {
                        $valor .= "<tr>
                                     <td class=\"default\"><a
ref=\"editar.php?ID=".odbc_result( $result, 1 )."\">Editar</a></td>
                                                         <td class=\"default\"><a
href=\"#\" onClick=\"window.open('detalhes.php?ID=".odbc_result( $result, 1 )
."','Detalhes','width=350,height=200')\">".odbc_result( $result, 2 )."</a></td>
                                                         <td class=\"default\"><a
href=\"#\" onClick=\"window.open('detalhes.php?ID=".odbc_result( $result, 1 )
."','Detalhes','width=350,height=200')\">".odbc_result( $result, 6 )."</a></td>
                                                         <td class=\"default\"><a
href=\"#\" onClick=\"window.open('detalhes.php?ID=".odbc_result( $result, 1 )
."','Detalhes','width=350,height=200')\">(".odbc_result( $result, 4 )
.")".odbc_result( $result, 5 )."</a></td>
                                                         <td class=\"default\"><a
href=\"#\" onClick=\"window.open('excluir.php?ID=".odbc_result( $result, 1 )
."','Detalhes','width=1,height=1')\">Excluir</a></td>
                                                   </tr>";
                }
         }
         return $valor;
}

//Corpo principal do script
$usuario = trim($_SESSION['USUARIO']); //recbe os dados da sessão

if ( ( $usuario != "" )&&( $usuario != "" ) ) {//Testa o usuário

         if ( !$con ) { //Testa se existe conexão
               //Conecta ao banco
               conecta(BANCO,USUARIO,SENHA);//Conectando ao banco
         }

         //Grava a saida da função na variavel
         $linhas = listar_agenda();
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
//Incluindo o Menu
include("menu.html");
?>

              </td></tr>
              <td valign=top>
                    <table cellspacing=1 cellpadding=1 width="100%" border=0
bgcolor=White>
         <tr>
            <td width="60" class="headers"><b><a href="#">Editar</a></b></td>
            <td width="210" class="headers"><b><a href="#">Nome</a></b></td>
            <td width="210" class="headers"><b><a href="#">Email</a></b></td>
            <td width="100" class="headers"><b><a href="#">Fone</a></b></td>
            <td width="60" class="headers"><b><a href="#">Excluir</a></b></td>
         </tr>
         <?=$linhas?>
       </table>
              </td>
       </tr>
</table>
</body>
</html>
<?
   } else {
     //Direciona para a tela inicial
     header("location: index.php");
}
?>
