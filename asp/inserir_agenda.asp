<!-- #include file="funcoes.asp" -->
<%
'Função : Insere os dados na Agenda
'Desenvolvedor : Cerli Rocha
'Data : 30/05/2003
'Atualização: 30/06/2003

function inserir_agenda( nome, endereco, ddd, fone, email, observacoes )
    sql = "INSERT INTO Agenda( NOME, ENDERECO, DDD, FONE, EMAIL, OBSERVACOES ) VALUES( '" & nome & "', '" & endereco & "', '" & ddd & "', '" & fone & "', '" & email & "', '" & observacoes & "' )"
    con.Execute sql
    inserir_agenda = true
end function

login       = Session("USUARIO")
nome        = Request.Form("NOME")
endereco    = Request.Form("ENDERECO")
ddd         = Request.Form("DDD")
fone        = Request.Form("FONE")
email       = Request.Form("EMAIL")
observacoes = Request.Form("OBSERVACOES")

if ((login <> "") AND (NOT(isNull(login)))) then
    if (con = "") then
        call conecta(BANCO, USUARIO, SENHA, con)
    end if

    if (inserir_agenda(nome, endereco, ddd, fone, email, observacoes)) then
        Response.Redirect("listar.asp")
    else
        Response.Redirect("index.asp")
    end if
else
    Response.Redirect("index.asp")
end if
%>
