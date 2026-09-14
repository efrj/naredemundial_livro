<!-- #include file="funcoes.asp" -->
<%
'Função       : Tela de Busca
'Desenvolvedor: Cerli Rocha
'Data       : 20/06/2003
'Atualização : 30/06/2003

login = Session("USUARIO")

if ((login <> "") AND (NOT(isNull(login)))) then
%>
<html>
<head>
    <title>:: Agenda ASP ::</title>
</head>
<body bgcolor="#778899">
<table border=0 align=center bgcolor=White width="700">
    <tr>
        <td valign=top width="100%" align=center><!-- #include file="menu.html" --></td>
    </tr>
    <tr>
        <td valign=top>
            <form name="form1" action="search.asp" method=post>
                <table width="100%" border="0" align="center">
                    <tr>
                        <td bgcolor=white>
                            <table width="100%" border="0" align="center">
                                <tr>
                                    <td align=right colspan=2>.: <b>Buscar na Agenda</b> :.</td>
                                </tr>
                                <tr>
                                    <td align=right width="30%"><b>Palavra-chave</b>: &nbsp;</td>
                                    <td><input name="KEY" type=text id="KEY" value="" size=30 maxlength="50"></td>
                                </tr>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td>
                                        <input type=submit name=submit value="Buscar &gt;&gt;">
                                        <input type=reset name=submit2 value="Limpar &gt;&gt;">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </form>
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
