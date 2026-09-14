<!-- #include file="funcoes.asp" -->
<%
'Função       : Exibe os Detalhes
'Desenvolvedor: Cerli Rocha
'Data        : 20/06/2003
'Atualização : 30/06/2003

function editar_agenda( ID )
    sql = "SELECT ID, NOME, ENDERECO, DDD, FONE, EMAIL, OBSERVACOES, Data FROM Agenda WHERE ID = " & ID
    Set rs = New Recordset
    rs.Open sql, con
    Do While Not rs.EOF
        nome = rs(1)
        endereco = rs(2)
        ddd = rs(3)
        fone = rs(4)
        email = rs(5)
        observacoes = rs(6)
        rs.MoveNext
    Loop
    rs.Close
    Set rs = Nothing
end function

login = Session("USUARIO")
id = trim(Request.QueryString("ID"))
Dim nome
Dim endereco
Dim ddd
Dim fone
Dim email
Dim observacoes

if ((login <> "") AND (NOT(isNull(login)))) then
    if (con = "") then
        call conecta(BANCO, USUARIO, SENHA, con)
    end if
    call editar_agenda(id)
%>
<html>
<head>
    <title>:: Agenda ASP ::</title>
</head>
<body bgcolor="#778899">
<table border=0 align=center bgcolor=White width="100%">
    <tr>
        <td valign=top>
            <table width="100%" border="0" align="center">
                <tr>
                    <td bgcolor=white>
                        <table width="100%" border="0" align="center">
                            <tr>
                                <td align=right colspan=2>.: <b>Detalhes da Agenda</b> :.</td>
                            </tr>
                            <tr>
                                <td align=right width="30%"><b>Nome</b>: &nbsp;</td>
                                <td><%=nome%></td>
                            </tr>
                            <tr>
                                <td align=right width="30%"><b>Endere&ccedil;o</b>: &nbsp;</td>
                                <td><%=endereco%></td>
                            </tr>
                            <tr>
                                <td><b>Fone</b>: </td>
                                <td><%=ddd%> - <%=fone%></td>
                            </tr>
                            <tr>
                                <td><b>Email</b>: </td>
                                <td><%=email%></td>
                            </tr>
                            <tr>
                                <td><b>Observa&ccedil;&otilde;es</b>: </td>
                                <td><%=observacoes%></td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td><a href="#" onClick="self.close()">fechar</a></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</body>
</html>
<%
else
    response.Write("<script>self.close()</script>")
end if
%>
