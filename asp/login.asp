<!-- #include file="funcoes.asp" -->
<%
‘Função : Autentica o usuario
‘Desenvolvedor : Cerli Rocha
‘Data : 30/05/2003
‘Atualização: 30/06/2003

function autentica_usuario( LOGIN, PASS )
             valor = false

             if ( ( LOGIN = USUARIO )AND( PASS = SENHA ) ) then
                    valor = true
                      else
                        valor = false
             end if

          autentica_usuario = valor

end function


'Corpo Principal do Script
login = Request.Form("LOGIN")
pass = Request.Form("SENHA")

if ( ( login <> "" )AND( NOT(isNull(login)) ) ) then

         if ( autentica_usuario(login,pass) ) then
              Session("USUARIO") = login
                  Response.Redirect("listar.asp")
                else
                  Response.Redirect("index.asp")
           end if

          else
          Response.Redirect("index.asp")
end if
%>
