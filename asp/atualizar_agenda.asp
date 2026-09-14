<!-- #include file="funcoes.asp" -->
<%
'Função       : Atualizar os dados na agenda
'Desenvolvedor: Cerli Rocha
'Data        : 20/06/2003
'Atualização : 30/06/2003

function atualizar_agenda( nome, endereco, ddd, fone, email, observacoes, id )
    sql = "UPDATE Agenda SET NOME = '" & nome & "', ENDERECO = '" & endereco & "', DDD = '" & ddd & "', FONE = '" & fone & "', EMAIL = '" & email & "', OBSERVACOES = '" & observacoes & "' WHERE ID = " & id
    con.Execute sql
    atualizar_agenda = true
end function

'Recebendo os Dados do Formulário
login       = Session("USUARIO")'Lendo a Sessão
nome        = Request.Form("NOME")
endereco    = Request.Form("ENDERECO")
ddd         = Request.Form("DDD")
fone        = Request.Form("FONE")
email       = Request.Form("EMAIL")
observacoes = Request.Form("OBSERVACOES")
id          = Request.Form("ID")

'Testando se o usuario está logado
if ((login <> "") AND (NOT(isNull(login)))) then
    if (con = "") then
        call conecta(BANCO, USUARIO, SENHA, con)
    end if

    if (atualizar_agenda(nome, endereco, ddd, fone, email, observacoes, id)) then
        Response.Redirect("listar.asp")
    else
        Response.Redirect("index.asp")
    end if
else
    Response.Redirect("index.asp")
end if
%>
