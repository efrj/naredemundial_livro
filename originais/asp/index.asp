<!-- #include file="funcoes.asp" -->
<%
‘Função : Exibe a tela para login
‘Desenvolvedor : Cerli Rocha
‘Data : 30/05/2003
‘Atualização: 30/06/2003

Session.Abandon
%>
<html>
<head>
      <title>:: Agenda ASP ::</title>

</head>
<body bgcolor="#778899" >
<form name="form1" action="login.asp" method=post>
<table width="400" border="0" align="center">
    <tr>
            <td bgcolor=white>
                  <table width="100%" border="0" align="center">
                <tr>
                     <td align=right colspan=2>.: <b>Bem Vindo. Por favor informe
seus dados</b> :.</td>
                         </tr>
                <tr>
                     <td align=right width="30%"><b>Login</b>: &nbsp</td>
                     <td><input name="LOGIN" type=text id="LOGIN"
style="width:80px" value="" size=5></td>
                         </tr>
                <tr>
                         </tr>

                    <td align=right width="30%"><b>Senha</b>: &nbsp</td>
                    <td><input name="SENHA" type=password id="SENHA"
style="width:80px" value="" size=5></td>
                </tr>
                        <tr>
                    <td>&nbsp;</td>
                    <td><input type=submit name=submit value="Acessar
&gt&gt"></td>
                      </tr>
          </table>
            </td>
      </tr>
</table>
</form>
</body>
</html>
