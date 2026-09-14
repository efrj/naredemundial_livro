<%@ page import = "java.lang.*,java.io.*,java.util.*,java.sql.*" %>
<%@ include file="funcoes.jsp" %>
<%!
/*
Função       : Atualizar os dados na agenda
Desenvolvedor: Cerli Rocha
Data         : 20/06/2003
Atualização : 30/06/2003

public boolean atualizar_agenda( String nome, String endereco, String ddd,
String fone, String email, String observacoes, String id ) {
       String sql    = "";
         boolean valor = false;

        Statement stmt;

         try {
            sql = "UPDATE Agenda SET NOME = '" + nome + "', ENDERECO = '" +
endereco + "', DDD = '" + ddd + "', FONE = '" + fone + "', EMAIL = '" + email +
"', " +
                        " OBSERVACOES = '" + observacoes + "' WHERE ID = " +
String.valueOf(id);
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
String id = request.getParameter("ID");

//Tastando se o usuario está logado
if ( ( usuario != null ) ) {

         if ( atualizar_agenda( nome, endereco, ddd, fone, email, observacoes,
id ) ) {//Executando a Função
            response.sendRedirect("listar.jsp");//Página Principal
                  } else {
                  response.sendRedirect("index.jsp");//Login
         }

        } else {
        response.sendRedirect("index.jsp");//Login

}
%>
