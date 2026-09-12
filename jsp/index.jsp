<%@ page import = "java.lang.*,java.io.*,java.util.*,java.sql.*" %>
<%@ include file="funcoes.jsp" %>
<%
/*
Função : Exibe a tela para login
Desenvolvedor : Cerli Rocha
Data : 30/05/2003
Atualização: 30/06/2003
*/

String usuario = (String)session.getAttribute("USUARIO");

if ( ( usuario != null ) ) {
%>
<html>
<head>
      <title>:: Agenda JSP ::</title>

</head>
<body bgcolor="#778899" >
<table border=0 align=center bgcolor=White width="700">
      <tr>
            <td valign=top width="100%" align=center>
                  <%@ include file="menu.html" %>
            </td></tr>

    <td valign=top>
      <form name="form1" action="inserir_agenda.jsp" method=post>
        <table width="100%" border="0" align="center">
          <tr>
            <td bgcolor=white> <table width="100%" border="0" align="center">
                <tr>
                  <td align=right colspan=2>.: <b>Inserir Nomes
                     na Agenda</b> :.</td>
                </tr>
                <tr>
                  <td align=right width="30%"><b>Nome</b>: &nbsp;</td>
                  <td><input name="NOME" type=text id="NOME" value="" size=30
maxlength="50"></td>
                </tr>
                <tr> </tr>

                    <td align=right width="30%"><b>Endere&ccedil;o</b>:
                       &nbsp;</td>
                  <td><input name="ENDERECO" type=text id="ENDERECO" value=""
size=30 maxlength="100"></td>
                  </tr>
                  <tr>
                    <td><b>Fone</b>: </td>
                    <td><input name="DDD" type=text id="DDD" value="" size=3
maxlength="3">
                       -
                       <input name="FONE" type=text id="FONE" value="" size=7
maxlength="10"></td>
                  </tr>
                  <tr>
                    <td><b>Email</b>: </td>
                    <td><input name="EMAIL" type=text id="EMAIL" value="" size=30
maxlength="50"></td>
                  </tr>
                  <tr>
                    <td><b>Observa&ccedil;&otilde;es</b>: </td>
                    <td><textarea name="OBSERVACOES" cols="22" rows="5"
id="OBSERVACOES"></textarea></td>
                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                    <td><input type=submit name=submit value="Gravar &gt;&gt;">
                       <input type=reset name=submit2 value="Limpar &gt;&gt;"></td>
                  </tr>
                </table></td>
            </tr>
         </table>
       </form></td>
       </tr>
</table>
</body>
</html>
<%
   } else {
     response.sendRedirect("index.jsp");
}
%>
