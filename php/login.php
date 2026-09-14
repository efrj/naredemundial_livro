<?
/*
Função : Autentica o usuario
Desenvolvedor : Cerli Rocha
Data : 30/05/2003
Atualização: 30/06/2003
*/

session_start(); //inicializa a sessão
include("funcoes.php"); //inclui o arquivo de funções

//Função que autentica o usuario
function autentica_usuario($USUARIO, $SENHA)
{
    global $con;
    $valor = false;

    //Compara o usuario e senha recebidos com as contantes definidas no //funcoes.php
    if (($USUARIO == USUARIO) && ($SENHA == SENHA)) {
        $valor = true;
    } else {
        $valor = false;
    }

    return $valor; //Retorna o resultado
}

//Corpo Principal do Script
$login = trim($_POST['LOGIN']); //Recebe o login
$senha = trim($_POST['SENHA']); //recebe a senha

if (($login != "") && ($login != NULL)) { //Testa o login

    //chama a função autentica_usuario
    if (autentica_usuario($login, $senha)) {
        $_SESSION['USUARIO'] = $login; //Grava o login na sessão
        header("location: listar.php"); //Direciona para a agenda
    } else {
        header("location: index.php"); //Direciona para a tela inicial
    }

} else {
    header("location: index.php"); //Direciona para a tela inicial
}
?>