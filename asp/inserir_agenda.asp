<!-- #include file="funcoes.asp" -->
<%
‘Função : Insere os dados na Agenda
‘Desenvolvedor : Cerli Rocha
‘Data : 30/05/2003
‘Atualização: 30/06/2003

function inserir_agenda( nome, endereco, ddd, fone, email, observacoes )
             valor = true
         sql    = "INSERT INTO Agenda( NOME, ENDERECO, DDD, FONE, EMAIL,
OBSERVACOES ) " & _
                      "VALUES( '" & nome & "', '" & endereco & "', '" & ddd &
"', '" & fone & "', '" & email & "', '" & observacoes & "' )"
         set rs = con.execute(sql)


               if rs is nothing then
              valor = false
              else
                valor = true
           end if

               set rs = nothing
               inserir_agenda = valor
end function

login       = Session("USUARIO")
nome        = Request.Form("NOME")
endereco    = Request.Form("ENDERECO")
ddd         = Request.Form("DDD")
fone        = Request.Form("FONE")
email       = Request.Form("EMAIL")
observacoes = Request.Form("OBSERVACOES")

if ( ( login <> "" )AND( NOT(isNull(login)) ) ) then

         if ( con = "" ) then
                    call conecta( BANCO, USUARIO, SENHA, con )
           end if

         if ( inserir_agenda( nome, endereco, ddd, fone, email, observacoes ) )
then
              Response.Redirect("listar.asp")
                    else
              Response.Redirect("index.asp")
         end if

          else
          Response.Redirect("index.asp")
end if
%>
