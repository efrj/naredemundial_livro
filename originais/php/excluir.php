<?
/*
Função       : Exclui os dados da agenda
Desenvolvedor: Cerli Rocha
Data         : 20/06/2003
Atualização : 30/06/2003
*/

session_start(); //Inicializa a sessão
include("funcoes.php"); //Inclui o arquivo de funções

//Função que exclui os dados da agenda
function excluir_agenda( $id ) {
         global $con;
         $valor = false;
         $sql   = "DELETE FROM Agenda WHERE ID = $id";
         $result = odbc_exec( $con, $sql );
         if (!$result) {
              $valor = false;
              } else {
                $valor = true;
         }
         return $valor;
}

//Corpo Principal do script


$usuario       = trim($_SESSION['USUARIO']); //Recebe os dados da sessão
$id            = $_GET['ID'];

//Testa se o usuario está logado
if ( ( $usuario != "" )&&( $usuario != "" ) ) {

           if ( !$con ) { //Testa se existe conexão ao banco
                 conecta(BANCO,USUARIO,SENHA);//Conectando ao banco
           }

           //Chama a função de exclusão
           if ( excluir_agenda( $id ) ) {
                print "<script>
                        opener.location.reload();
                        self.close();
                       </script>";
                } else {
                 print "<script>
                         self.close();
                        </script>";
           }

           } else {
             print "<script>
                     opener.location = 'index.php';
                     self.close();
                    </script>";
}
?>
