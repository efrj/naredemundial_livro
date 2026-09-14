<%!
/*
Função        : Fornecer variáveis, constantes e funções comuns
Desenvolvedor : Cerli Rocha
Data          : 30/05/2003
Atualização   : 30/06/2003
*/

public final String USUARIO = "agenda";
public final String SENHA   = "agenda";

public boolean autentica_usuario( String usuario, String senha ) {

        boolean valor = false;


            if ( ( usuario.equals(USUARIO) )&&( senha.equals(SENHA) ) ) {
                   valor = true;

                      } else {
                          valor = false;
             }
         return valor;
}

     Connection con = null;

%>
<%

     String driverName = "sun.jdbc.odbc.JdbcOdbcDriver";
     String serverURLBase = "jdbc:odbc:";
     String dbName = "Agenda";

//Conecta
try {
       Class.forName(driverName);
       con        = DriverManager.getConnection(serverURLBase+dbName);
      } catch (Exception e){

        }
//Fim do conecta
%>
