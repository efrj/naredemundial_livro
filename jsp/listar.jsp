<%@ page import = "java.lang.*,java.io.*,java.util.*,java.sql.*" %>
<%@ include file="funcoes.jsp" %>
<%!
Função : Lista os nomes cadastrados na agenda
Desenvolvedor : Cerli Rocha
Data : 30/05/2003
Atualização: 30/06/2003
*/

public String listar_agenda() {

         String valor = "";
         String sql   = "";

         String id = "";
         String nome = "";
         String endereco = "";
         String ddd = "";
         String fone = "";
         String email = "";
         String observacoes = "";

         Statement stmt;
         ResultSet rs;

       //Select
       try {
             sql = "SELECT ID, NOME, ENDERECO, DDD, FONE, EMAIL, OBSERVACOES,
DATA FROM Agenda";
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

                  valor += "<tr>" +
                                               "<td class=\"default\"><a
href=\"editar.jsp?ID=" + id + "\">Editar</a></td>" +
                                             "<td class=\"default\"><a
href=\"#\" onClick=\"window.open('detalhes.jsp?ID=" + id +
"','Detalhes','width=350,height=200')\">" + nome + "</a></td>" +
                                               "<td class=\"default\"><a
href=\"#\" onClick=\"window.open('detalhes.jsp?ID=" + id +
"','Detalhes','width=350,height=200')\">" + email + "</a></td>" +
                                               "<td class=\"default\"><a
href=\"#\" onClick=\"window.open('detalhes.jsp?ID=" + id +
"','Detalhes','width=350,height=200')\">(" + ddd + ")" + fone + "</a></td>" +



                                               "<td class=\"default\"><a
href=\"#\" onClick=\"window.open('excluir.jsp?ID=" + id +
"','Detalhes','width=1,height=1')\">Excluir</a></td>" +
                                         "</tr>";


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
%>
<%

String usuario = (String)session.getAttribute("USUARIO");

if ( ( usuario != null ) ) {

       String linhas = listar_agenda();
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
 } else {

     response.sendRedirect("index.jsp");
}
%>
