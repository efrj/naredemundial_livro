<%@ page import = "java.lang.*,java.io.*,java.util.*,java.sql.*" %>
<%@ include file="funcoes.jsp" %>
<%!
/*
Função       : Exclui os dados da agenda
Desenvolvedor: Cerli Rocha
Data         : 20/06/2003
Atualização : 30/06/2003
*/

public boolean excluir_agenda( String id ) {
       String sql    = "";
         boolean valor = false;

          Statement stmt;

          try {
             sql = "DELETE FROM Agenda WHERE ID = " + String.valueOf(id);
             stmt = con.createStatement ();
             int linhas = stmt.executeUpdate(sql);

              if (linhas > 0) {
                    valor = true;
                  } else {
                      valor = false;
                }

          } catch(SQLException e) {
                  e.printStackTrace();
          }
          return valor;
}
%>
<%
String usuario = (String)session.getAttribute("USUARIO");
String id = request.getParameter("ID");



if ( ( usuario != null ) ) {

           if ( excluir_agenda( id ) ) {
              out.println("<script>" +
                                  "opener.location.reload();" +
                                      "self.close();" +
                                "</script>");
                    } else {
                      out.println("<script> " +
                                 "self.close(); " +
                                "</script>");
       }

           } else {
           out.println("<script>" +
                            "opener.location = 'index.jsp';" +
                              "self.close();" +
                            "</script>");
}
%>
