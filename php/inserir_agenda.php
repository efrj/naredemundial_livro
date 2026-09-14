<?
/*
Função : Insere os dados na Agenda
Desenvolvedor : Cerli Rocha
Data : 30/05/2003
Atualização: 30/06/2003
*/

session_start(); //Inicializa a sessão
include("funcoes.php"); //Inclui o arquivo de funções

//Função que insere os dados na agenda
function inserir_agenda($nome, $endereco, $ddd, $fone, $email, $observacoes)
{
    global $con;
    $valor = false;
    $sql = "INSERT INTO Agenda( NOME, ENDERECO, DDD, FONE, EMAIL, OBSERVACOES ) VALUES( '$nome', '$endereco', '$ddd', '$fone', '$email', '$observacoes' )";
    $result = odbc_exec($con, $sql);
    if (!$result) {
        $valor = false;
    } else {
        $valor = true;
    }
    return $valor;
}

//Corpo Principal do script
$usuario = trim($_SESSION['USUARIO']); //Recebe dados da sessão
$nome = $_POST['NOME'];
$endereco = $_POST['ENDERECO'];
$ddd = $_POST['DDD'];
$fone = $_POST['FONE'];
$email = $_POST['EMAIL'];
$observacoes = $_POST['OBSERVACOES'];

//Testa o usuario
if (($usuario != "") && ($usuario != "")) {

    if (empty($con)) { //Testa a conexão ao banco
        conecta(BANCO, USUARIO, SENHA);//Conectando ao banco
    }

    //Chama a função que insere os dados na agenda
    if (inserir_agenda($nome, $endereco, $ddd, $fone, $email, $observacoes)) {
        header("location: listar.php"); //Direciona pra tela de listar
    } else {
        header("location: index.php"); //Direciona pra tela inicial
    }

} else {
    header("location: index.php"); //Direciona pra tela incial
}
?>