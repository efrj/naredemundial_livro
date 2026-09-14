<?
/*
Função        : Fornecer variáveis, constantes e funções comuns
Desenvolvedor : Cerli Rocha
Data          : 30/05/2003
Atualização   : 30/06/2003
*/

define("BANCO","AGENDA"); //Constante com o nome da base de dados
define("USUARIO","agenda"); //Constante com o nome do usuário da base de dados
define("SENHA","agenda"); //Constante com a senha do usuário da base de dados

//Função que executa a conexão a base de dados
function conecta( $BANCO, $USER, $PASS ) {
         global $con;
         $con = @odbc_connect($BANCO,$USER,$PASS);
}
?>
