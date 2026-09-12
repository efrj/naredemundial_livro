<%@ page import = "java.lang.*,java.io.*,java.util.*,java.sql.*" %>
<%@ include file="funcoes.jsp" %>
<%!
/*
Função       : Abre a Agenda para edição
Desenvolvedor: Cerli Rocha
Data         : 20/06/2003
Atualização : 30/06/2003
*/

public String editar_agenda( String ID ) {
         String valor = "";
         String sql   = "";


           Statement stmt;
           ResultSet rs;

       //Select
       try {
             sql = "SELECT ID, NOME, ENDERECO, DDD, FONE, EMAIL, OBSERVACOES,
DATA FROM Agenda WHERE ID = " + ID;
             stmt = con.createStatement();
             stmt.execute(sql);
             rs = stmt.getResultSet();
             while(rs.next()) {
                           id          = rs.getString(1);
                       nome        = rs.getString(2);
                         endereco    = rs.getString(3) ;
                           ddd         = rs.getString(4);
                           fone        = rs.getString(5);
                           email       = rs.getString(6);
                           observacoes = rs.getString(7);
             }

              stmt.close();
              if (!con.isClosed()) {
                     con.close();
              }
         } catch (Exception e) {
                      try {
                          if (!con.isClosed()) {
                          }
                        } catch (Exception ex){
                          }
         }
       return valor;
}

        String id = "";
             String nome = "";
             String endereco = "";
                 String ddd = "";
                 String fone = "";
                 String email = "";
                 String observacoes = "";

%>


<%
String usuario = (String)session.getAttribute("USUARIO");
String id      = request.getParameter("ID");


if ( ( usuario != null ) ) {

        editar_agenda(id);
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
      <form name="form1" action="atualizar_agenda.jsp" method=post>
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
class="textbox" id="NOME" value="<%=nome%>" size=30 maxlength="50"></td>
                  </tr>
                  <tr> </tr>
                    <td align=right class="right"
width="30%"><b>Endere&ccedil;o</b>:
                       &nbsp;</td>
                  <td class="default1"><input name="ENDERECO" type=text
class="textbox" id="ENDERECO" value="<%=endereco%>" size=30
maxlength="100"></td>
                  </tr>
                  <tr>
                    <td class="right"><b>Fone</b>: </td>
                    <td class="default1"><input name="DDD" type=text
class="textbox" id="DDD" value="<%=ddd%>" size=3 maxlength="3">
                       -
                       <input name="FONE" type=text class="textbox" id="FONE"
value="<%=fone%>" size=7 maxlength="10"></td>
                  </tr>
                  <tr>
                    <td class="right"><b>Email</b>: </td>
                    <td class="default1"><input name="EMAIL" type=text
class="textbox" id="EMAIL" value="<%=email%>" size=30 maxlength="50"></td>
                  </tr>
                  <tr>
                    <td class="right"><b>Observa&ccedil;&otilde;es</b>: </td>
                    <td class="default1"><textarea name="OBSERVACOES" cols="22"
rows="5" class="textbox" id="OBSERVACOES"><%=observacoes%></textarea></td>
                  </tr>
                  <tr>
                    <td class="right">&nbsp;</td>
                    <td class="default1">
                               <input type="hidden" name="ID" value="<%=id%>">
                                 <input type=submit name=submit value="Gravar
&gt;&gt;" class="button">
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
