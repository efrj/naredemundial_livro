<!-- #include file="funcoes.asp" -->
<%
‘Função       : Exibe os Detalhes
‘Desenvolvedor: Cerli Rocha
‘Data        : 20/06/2003
‘Atualização : 30/06/2003

'Busca os dados da agenda de acordo com o Código recebido
function editar_agenda( ID )
         sql    = "SELECT ID, NOME, ENDERECO, DDD, FONE, EMAIL, OBSERVACOES,
Data FROM Agenda WHERE ID = " & ID
         Set rs = Server.CreateObject("ADODB.Recordset")
         rs.Open sql, con
             Do While Not rs.EOF
              nome         = rs(1)
                  endereco     = rs(2)
                  ddd          = rs(3)
                  fone         = rs(4)
                  email        = rs(5)
                  observacoes = rs(6)
                rs.MoveNext
         Loop
         rs.Close
             set rs = Nothing
end function

'Lendo a Sessão
login = Session("USUARIO")
'Lendo o Código
id    = trim(Request.QueryString("ID"))
Dim nome
Dim endereco
Dim ddd
Dim fone
Dim email
Dim observacoes


'Tastando se o usuario está logado
if ( ( login <> "" )AND( NOT(isNull(login)) ) ) then

         if ( con = "" ) then
                  call conecta( BANCO, USUARIO, SENHA, con )
         end if

       call editar_agenda(id)
%>

<html>
<head>
      <title>:: Agenda ASP ::</title>

</head>
<body bgcolor="#778899" >
<table border=0 align=center bgcolor=White width="100%">
    <td valign=top>
         <table width="100%" border="0" align="center">
           <tr>
             <td bgcolor=white> <table width="100%" border="0" align="center">
                <tr>
                  <td align=right colspan=2>.: <b>Inserir Nomes na
                     Agenda</b> :.</td>
                </tr>
                <tr>
                  <td align=right width="30%"><b>Nome</b>: &nbsp</td>
                  <td>
<%=nome%>
                  </td>
                </tr>
                <tr> </tr>
                <td align=right width="30%"><b>Endere&ccedilo</b>:
                  &nbsp</td>
                <td>
                  <%=endereco%>
                </td>
                </tr>
                <tr>
                  <td><b>Fone</b>: </td>
                  <td>
                     <%=ddd%>
                     -
                     <%=fone%>
                  </td>
                </tr>
                <tr>
                  <td><b>Email</b>: </td>
                  <td>
                     <%=email%>
                  </td>
                </tr>
                <tr>
                  <td><b>Observa&ccedil&otildees</b>: </td>
                  <td>
                     <%=observacoes%>
                  </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td><a href="#" onClick="self.close()" >fechar</a></td>
                </tr>
             </table></td>
           </tr>
         </table>
      </td>
      </tr>
</table>
</body>
</html>

<%
   else
     response.Write("<script>" & _
                          "self.close()" & _
                        "</script>")
end if
%>
