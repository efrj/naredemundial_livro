<%
‘Função        : Fornecer variáveis, constantes e funções comuns
‘Desenvolvedor : Cerli Rocha
‘Data          : 30/05/2003
‘Atualização   : 30/06/2003

Const BANCO   = "AGENDA"
Const USUARIO = "agenda"
Const SENHA   = "agenda"
Dim con

function conecta( BANCO, USUARIO, SENHA, byRef con )
         Set con = Server.CreateObject("ADODB.Connection")
         con.Open "DSN=" & BANCO & ";UID=" & USUARIO & ";PWD=" & SENHA
end function
%>
