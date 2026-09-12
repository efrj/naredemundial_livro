<!-- #include file="funcoes.asp" -->
<%
‘Função       : Exclui os dados da agenda
‘Desenvolvedor: Cerli Rocha
‘Data        : 20/06/2003
‘Atualização : 30/06/2003

function excluir_agenda( id )
             valor = true
         sql   = "DELETE FROM Agenda WHERE ID = " & id
         set rs = con.execute(sql)

               if rs is nothing then
              valor = false
              else
                valor = true
           end if

               set rs = nothing
               excluir_agenda = valor
end function

login = Session("USUARIO")
id          = Request.QueryString("ID")

if ( ( login <> "" )AND( NOT(isNull(login)) ) ) then
         if ( con = "" ) then
                  call conecta( BANCO, USUARIO, SENHA, con )

          end if

         if ( excluir_agenda( id ) ) then
              response.Write("<script>" & _
                                     "opener.location.reload();" & _
                                         "self.close();" & _
                                   "</script>")
                    else
              response.Write("<script>" & _
                                         "self.close();" & _
                                   "</script>")
           end if

          else
             response.Write("<script>" & _
                                    "opener.location = 'index.asp';" & _
                                        "self.close();" & _
                                  "</script>")
end if
%>
