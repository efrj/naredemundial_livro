<%@ page import = "java.lang.*,java.io.*,java.util.*,java.sql.*" %>
<%@ include file="funcoes.jsp" %>
<%!
/*
Função       : Exibe os Detalhes
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

//Tastando se o usuario está logado
if ( ( usuario != null ) ) {

       editar_agenda(id);
%>
<html>
<head>
      <title>:: Agenda JSP ::</title>

</head>
<body bgcolor="#778899" >
<table border=0 align=center bgcolor=White width="100%">
    <td valign=top>
        <table width="100%" border="0" align="center">
          <tr>
            <td bgcolor=white> <table width="100%" border="0" align="center">
               <tr>
                 <td align=right colspan=2>.: <b>Inserir Nomes na
                    Agenda</b> :.</td>
               </tr>
               <tr>
                 <td align=right width="30%"><b>Nome</b>: &nbsp;</td>
                 <td>
                    <%=nome%>
                 </td>
               </tr>
               <tr> </tr>
               <td align=right width="30%"><b>Endere&ccedil;o</b>:
                 &nbsp;</td>
               <td>
                 <%=endereco%>
               </td>
               </tr>
               <tr>
                 <td><b>Fone</b>: </td>
                 <td>
                    <%=ddd%>
                    -
                    <%=fone%>
                 </td>
               </tr>
               <tr>
                 <td><b>Email</b>: </td>
                 <td>
                    <%=email%>
                 </td>
               </tr>
               <tr>
                 <td><b>Observa&ccedil;&otilde;es</b>: </td>
                 <td>

                     <%=observacoes%>
                  </td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td><a href="#" onClick="self.close()" >fechar</a></td>
                </tr>
              </table></td>
            </tr>
         </table>
       </td>
       </tr>
</table>
</body>
</html>
<%
   } else {
       out.println("<script> " +
                  "self.close(); " +
                 "</script>");

}
%>
