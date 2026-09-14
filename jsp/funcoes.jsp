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

//Conecta
try {
    if (agenda.Main.store != null) {
        con = agenda.Main.store.getJspConnection();
    }
} catch (Exception e) {
    e.printStackTrace();
}
//Fim do conecta
%>
