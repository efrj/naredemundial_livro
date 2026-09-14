<%@ page import = "java.lang.*,java.io.*,java.util.*,java.sql.*" %>
<%@ include file="funcoes.jsp" %>
<%!
/*
Função : Insere os dados na Agenda
Desenvolvedor : Cerli Rocha
Data : 30/05/2003
Atualização: 30/06/2003
*/

public boolean inserir_agenda( String nome, String endereco, String ddd, String
fone, String email, String observacoes ) {
       String sql    = "";
         boolean valor = false;

          Statement stmt;

          try {
             sql = "INSERT INTO Agenda( NOME, ENDERECO, DDD, FONE, EMAIL, OBSERVACOES ) " +
                       "VALUES( '" + nome + "', '" + endereco + "', '" + ddd + "', '" + fone + "', '" + email + "', '" + observacoes + "' )";
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
String usuario     = (String)session.getAttribute("USUARIO");
String nome        = request.getParameter("NOME");
String endereco    = request.getParameter("ENDERECO");
String ddd         = request.getParameter("DDD");
String fone        = request.getParameter("FONE");
String email       = request.getParameter("EMAIL");
String observacoes = request.getParameter("OBSERVACOES");

if ( ( usuario != null ) ) {

        if ( inserir_agenda( nome, endereco, ddd, fone, email, observacoes ) )
{
            response.sendRedirect("listar.jsp");
                  } else {
                  response.sendRedirect("index.jsp");
        }

        } else {
        response.sendRedirect("index.jsp");
}
%>
