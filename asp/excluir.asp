<!-- #include file="funcoes.asp" -->
<%
'Função       : Exclui os dados da agenda
'Desenvolvedor: Cerli Rocha
'Data        : 20/06/2003
'Atualização : 30/06/2003

function excluir_agenda( id )
    sql = "DELETE FROM Agenda WHERE ID = " & id
    con.Execute sql
    excluir_agenda = true
end function

login = Session("USUARIO")
id = Request.QueryString("ID")

if ((login <> "") AND (NOT(isNull(login)))) then
    if (con = "") then
        call conecta(BANCO, USUARIO, SENHA, con)
    end if

    if (excluir_agenda(id)) then
        response.Write("<script>opener.location.reload(); self.close();</script>")
    else
        response.Write("<script>self.close();</script>")
    end if
else
    response.Write("<script>opener.location = 'index.asp'; self.close();</script>")
end if
%>
