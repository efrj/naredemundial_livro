<!-- #include file="funcoes.asp" -->
<%
‘Função       : Abre a Agenda para edição
‘Desenvolvedor: Cerli Rocha
‘Data        : 20/06/2003
‘Atualização : 30/06/2003

function editar_agenda( ID )
         sql    = "SELECT ID, NOME, ENDERECO, DDD, FONE, EMAIL, OBSERVACOES,
Data FROM Agenda WHERE ID = " & ID
         Set rs = Server.CreateObject("ADODB.Recordset")
         rs.Open sql, con
             Do While Not rs.EOF
              nome         = rs(1)
                  endereco     = rs(2)
                  ddd          = rs(3)
                  fone         = rs(4)
                  email        = rs(5)
                  observacoes = rs(6)
                rs.MoveNext
         Loop
         rs.Close
             set rs = Nothing
end function

login = Session("USUARIO")
id    = trim(Request.QueryString("ID"))
Dim nome

Dim endereco
Dim ddd
Dim fone
Dim email
Dim observacoes

if ( ( login <> "" )AND( NOT(isNull(login)) ) ) then
         if ( con = "" ) then
                  call conecta( BANCO, USUARIO, SENHA, con )
         end if
       call editar_agenda(id)
%>
<html>
<head>
      <title>:: Agenda ASP ::</title>

</head>
<body bgcolor="#778899" >
<table border=0 align=center bgcolor=White width="700">
      <tr>
            <td valign=top width="100%" align=center><!-- #include
file="menu.html" --></td></tr>

    <td valign=top>
      <form name="form1" action="atualizar_agenda.asp" method=post>
        <table width="100%" border="0" align="center">
          <tr>
            <td bgcolor=white> <table width="100%" border="0" align="center">
                <tr>
                  <td align=right colspan=2>.: <b>Inserir Nomes
                     na Agenda</b> :.</td>
                </tr>
                <tr>
                  <td align=right width="30%"><b>Nome</b>: &nbsp</td>
                  <td><input name="NOME" type=text id="NOME" value="<%=nome%>"
size=30 maxlength="50"></td>
                </tr>
                <tr> </tr>
                  <td align=right width="30%"><b>Endere&ccedilo</b>:
                     &nbsp</td>
                <td><input name="ENDERECO" type=text id="ENDERECO"
value="<%=endereco%>" size=30 maxlength="100"></td>
                </tr>
                <tr>
                  <td><b>Fone</b>: </td>
                  <td><input name="DDD" type=text id="DDD" value="<%=ddd%>"
size=3 maxlength="3">
                     -
                     <input name="FONE" type=text id="FONE" value="<%=fone%>"
size=7 maxlength="10"></td>
                </tr>
                <tr>
                  <td><b>Email</b>: </td>
                  <td><input name="EMAIL" type=text id="EMAIL"
value="<%=email%>" size=30 maxlength="50"></td>
                </tr>
                <tr>
                  <td><b>Observa&ccedil&otildees</b>: </td>
                  <td><textarea name="OBSERVACOES" cols="22" rows="5"
id="OBSERVACOES"><%=observacoes%></textarea></td>

                  </tr>
                  <tr>
                    <td>&nbsp;</td>
                    <td>
                              <input type="hidden" name="ID" value="<%=id%>">
                                <input type=submit name=submit value="Gravar
&gt&gt">
                      <input type=reset name=submit2 value="Limpar &gt&gt"></td>
                  </tr>
               </table></td>
           </tr>
         </table>
       </form></td>
      </tr>
</table>
</body>
</html>
<%
 else
    Response.Redirect("index.asp")
end if

%>
