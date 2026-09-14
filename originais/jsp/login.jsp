<%@ page import = "java.lang.*,java.io.*,java.util.*,java.sql.*" %>
<%@ include file="funcoes.jsp" %>
<%
/*
Função : Autentica o usuario
Desenvolvedor : Cerli Rocha
Data : 30/05/2003
Atualização: 30/06/2003
*/

//Corpo Principal do Script
String login = request.getParameter("LOGIN");
String senha = request.getParameter("SENHA");

if ( login != null )     {


          if ( autentica_usuario(login,senha) ) {
          session.setAttribute("USUARIO",login);
                 response.sendRedirect("listar.jsp");
               } else {
                   response.sendRedirect("index.jsp");
          }


          } else {
              response.sendRedirect("index.jsp");
}
%>
