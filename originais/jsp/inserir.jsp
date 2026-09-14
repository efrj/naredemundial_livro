<%@ page import = "java.lang.*,java.io.*,java.util.*,java.sql.*" %>
<%@ include file="funcoes.jsp" %>
<%
/*
Função : Monta a tela para inserir nomes na agenda
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
      <link rel="stylesheet" href="estilos.css" type="text/css">
</head>
<body bgcolor="#778899" text="#FFFFFF" link="#FFFFFF" vlink="#FFFFFF"
alink="#FFFFFF">
<table cellspacing=2 cellpadding=0 border=0 align=center bgcolor=White
width="700">
      <tr>
            <td valign=top width="100%" align=center>
                  <%@ include file="menu.html" %>
            </td></tr>

    <td valign=top>
      <form name="form1" action="inserir_agenda.jsp" method=post>
        <table width="100%" border="0" cellspacing="0" cellpadding="2"
align="center">
          <tr>
            <td bgcolor=white> <table width="100%" border="0" cellspacing="1"
cellpadding="1" align="center">
                <tr>
                  <td align=right class="title" colspan=2>.: <b>Inserir Nomes
                     na Agenda</b> :.</td>
                </tr>
                <tr>
                  <td align=right class="right" width="30%"><b>Nome</b>:
&nbsp;</td>
                  <td class="default1"><input name="NOME" type=text
class="textbox" id="NOME" value="" size=30 maxlength="50"></td>
                </tr>
                <tr> </tr>
                  <td align=right class="right"
width="30%"><b>Endere&ccedil;o</b>:
                     &nbsp;</td>
                <td class="default1"><input name="ENDERECO" type=text
class="textbox" id="ENDERECO" value="" size=30 maxlength="100"></td>
                </tr>
                <tr>

                    <td class="right"><b>Fone</b>: </td>
                    <td class="default1"><input name="DDD" type=text
class="textbox" id="DDD" value="" size=3 maxlength="3">
                       -
                       <input name="FONE" type=text class="textbox" id="FONE"
value="" size=7 maxlength="10"></td>
                  </tr>
                  <tr>
                    <td class="right"><b>Email</b>: </td>
                    <td class="default1"><input name="EMAIL" type=text
class="textbox" id="EMAIL" value="" size=30 maxlength="50"></td>
                  </tr>
                  <tr>
                    <td class="right"><b>Observa&ccedil;&otilde;es</b>: </td>
                    <td class="default1"><textarea name="OBSERVACOES" cols="22"
rows="5" class="textbox" id="OBSERVACOES"></textarea></td>
                  </tr>
                  <tr>
                    <td class="right">&nbsp;</td>
                    <td class="default1"><input type=submit name=submit
value="Gravar &gt;&gt;" class="button">
                       <input type=reset name=submit2 value="Limpar &gt;&gt;"
class="button"></td>
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
