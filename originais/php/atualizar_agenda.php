<?
/*
Função       : Atualizar os dados na agenda
Desenvolvedor: Cerli Rocha
Data         : 20/06/2003
Atualização : 30/06/2003
*/

session_start(); //Inicializa a sessão
include("funcoes.php"); //Inclui o arquivo de funções

//atualiza os dados na agenda
function atualizar_agenda( $nome, $endereco, $ddd, $fone, $email, $observacoes,
$id ) {
   global $con;
   $valor = false;
   $sql   = "UPDATE Agenda SET NOME = '$nome', ENDERECO = '$endereco',
             DDD = '$ddd', FONE = '$fone', EMAIL = '$email',
             OBSERVACOES = '$observacoes' WHERE ID = $id";
   $result = odbc_exec( $con, $sql );
   if (!$result) {
        $valor = false;
        } else {
          $valor = true;
   }
   return $valor;
}

//Corpo principal do script
//Recebendo os Dados do Formulário
$usuario     = trim($_SESSION['USUARIO']);//Lendo a Sessão
$nome        = $_POST['NOME'];
$endereco    = $_POST['ENDERECO'];
$ddd         = $_POST['DDD'];
$fone        = $_POST['FONE'];
$email       = $_POST['EMAIL'];
$observacoes = $_POST['OBSERVACOES'];
$id          = $_POST['ID'];

//Testando se o usuario está logado
if ( ( $usuario != "" )&&( $usuario != "" ) ) {

       if ( !$con ) { //testa se existe conexão
             conecta(BANCO,USUARIO,SENHA);//Conectando ao banco
       }

       //Chama a função que atualiza os dados alterados
       if ( atualizar_agenda( $nome, $endereco, $ddd, $fone, $email,
$observacoes, $id ) ) {
            header("location: listar.php");//Direciona para o listar
            } else {
              header("location: index.php");//Direciona para tela inicial
       }

       } else {
         header("location: index.php");//Direciona para tela inicial
}


?>
