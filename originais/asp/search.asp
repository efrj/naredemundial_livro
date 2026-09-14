<!-- #include file="funcoes.asp" -->
<%
‘Função       : Buscar a palavra-chave na agenda
‘Desenvolvedor: Cerli Rocha
‘Data        : 20/06/2003
‘Atualização : 30/06/2003

function search( KEY )
             valor = ""
         sql    = "SELECT ID, NOME, ENDERECO, DDD, FONE, EMAIL, OBSERVACOES,
Data FROM Agenda " & _

                      "WHERE (NOME LIKE '%" & KEY & "%') OR (ENDERECO LIKE '%" &
KEY & "%') OR (DDD LIKE '%" & KEY & "%') OR (FONE LIKE '%" & KEY & "%') OR
(EMAIL LIKE '%" & KEY & "%')"
         Set rs = Server.CreateObject("ADODB.Recordset")
         rs.Open sql, con
             Do While Not rs.EOF
                valor = valor & "<tr>" & _
                                             "<td class=default><a
href=editar.asp?ID=" & rs(0) & ">Editar</a></td>" & _
                                             "<td class=default><a href=#
onClick=window.open('detalhes.asp?ID=" & rs(0) &
"','Detalhes','width=350,height=200')>" & rs(1) & "</a></td>" & _
                                             "<td class=default><a href=#
onClick=window.open('detalhes.asp?ID=" & rs(0) &
"','Detalhes','width=350,height=200')>" & rs(5) & "</a></td>" & _
                                             "<td class=default><a href=#
onClick=window.open('detalhes.asp?ID=" & rs(0) &
"','Detalhes','width=350,height=200')>(" & rs(3) & ")" & rs(4) & "</a></td>" & _
                                             "<td class=default><a href=#
onClick=window.open('excluir.asp?ID=" & rs(0) &
"','Detalhes','width=1,height=1')>Excluir</a></td>" & _
                                             "</tr>"
                rs.MoveNext
         Loop
         rs.Close
             set rs = Nothing
             search = valor
end function

login = Session("USUARIO")
key     = trim(Request.Form("KEY"))

if ( ( login <> "" )AND( NOT(isNull(login)) ) ) then

        if ( con = "" ) then
                 call conecta( BANCO, USUARIO, SENHA, con )
        end if

       linhas = search( key )
%>
<html>
<head>
      <title>:: Agenda ASP ::</title>

</head>
<body bgcolor="#778899" >
<table border=0 align=center bgcolor=White width="700">
      <tr>
             <td valign=top width="100%" align=center><!-- #include
file="menu.html" --></td></tr>
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

<%=linhas%>
       </table>
             </td>
      </tr>
</table>
</body>
</html>
<%
 else
    Response.Redirect("index.asp")
end if

%>
