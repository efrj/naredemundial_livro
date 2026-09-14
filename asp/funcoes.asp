<%
'Função        : Fornecer variáveis, constantes e funções comuns
'Desenvolvedor : Cerli Rocha
'Data          : 30/05/2003
'Atualização   : 30/06/2003

Const BANCO   = "AGENDA"
Const USUARIO = "agenda"
Const SENHA   = "agenda"
Dim con

Sub conecta( BANCO, USUARIO, SENHA, byRef con )
    Set con = New DbConnection
End Sub

Class DbConnection
    Public Sub Open(connStr)
        ' Connection open no-op
    End Sub

    Public Sub Execute(sql)
        Call ExecHttpDb(sql)
    End Sub
End Class

Class Recordset
    Private m_doc
    Private m_rows
    Private m_index
    Private m_count

    Public Property Get EOF
        EOF = (m_index >= m_count)
    End Property

    Public Sub Open(sql, con)
        Dim sqlUpper, op, body, pos1, pos2, key, idStr
        sqlUpper = UCase(Trim(sql))
        
        If InStr(sqlUpper, "WHERE ID =") > 0 Or InStr(sqlUpper, "WHERE ID=") > 0 Then
            idStr = Trim(Mid(sql, InStr(sql, "=") + 1))
            op = "get"
            body = "&ID=" & Server.URLEncode(idStr)
        ElseIf InStr(sqlUpper, "LIKE") > 0 Then
            pos1 = InStr(sql, "'%")
            If pos1 > 0 Then
                pos2 = InStr(pos1 + 2, sql, "%'")
                If pos2 > 0 Then
                    key = Mid(sql, pos1 + 2, pos2 - (pos1 + 2))
                Else
                    key = ""
                End If
            Else
                key = ""
            End If
            op = "list"
            body = "&KEY=" & Server.URLEncode(key)
        Else
            op = "list"
            body = ""
        End If

        Dim http
        Set http = Server.CreateObject("MSXML2.ServerXMLHTTP")
        http.Open "POST", "http://jsp:8081/agenda", False
        http.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
        http.Send "op=" & Server.URLEncode(op) & body

        Set m_doc = Server.CreateObject("MSXML2.DOMDocument")
        m_doc.async = False
        m_doc.loadXML(http.responseText)

        Set m_rows = m_doc.selectNodes("/result/row")
        If Not (m_rows Is Nothing) Then
            m_count = m_rows.length
        Else
            m_count = 0
        End If
        m_index = 0
    End Sub

    Public Sub MoveNext
        m_index = m_index + 1
    End Sub

    Public Default Property Get Fields(idx)
        Fields = ""
        If m_index < 0 Or m_index >= m_count Then Exit Property
        Dim rowNode, fieldNode, fieldName
        Set rowNode = m_rows.item(m_index)
        If rowNode Is Nothing Then Exit Property

        If IsNumeric(idx) Then
            Dim map
            map = Array("ID", "NOME", "ENDERECO", "DDD", "FONE", "EMAIL", "OBSERVACOES", "DATA")
            If idx >= 0 And idx <= UBound(map) Then
                fieldName = map(idx)
            Else
                Exit Property
            End If
        Else
            fieldName = UCase(CStr(idx))
        End If

        Set fieldNode = rowNode.selectSingleNode(fieldName)
        If Not (fieldNode Is Nothing) Then
            Fields = fieldNode.text
        End If
    End Property

    Public Sub Close
        Set m_rows = Nothing
        Set m_doc = Nothing
    End Sub
End Class

Sub ExecHttpDb(sql)
    Dim sqlUpper, op, body, idStr, fields, i, key, val, pos1, pos2
    sqlUpper = UCase(Trim(sql))
    fields = Array("NOME", "ENDERECO", "DDD", "FONE", "EMAIL", "OBSERVACOES")

    If InStr(sqlUpper, "UPDATE") > 0 Then
        op = "update"
        idStr = Trim(Request.Form("ID"))
        If idStr = "" Then
            pos1 = InStr(sqlUpper, "WHERE ID")
            If pos1 > 0 Then
                pos2 = InStr(pos1, sql, "=")
                If pos2 > 0 Then idStr = Trim(Mid(sql, pos2 + 1))
            End If
        End If
        body = "&ID=" & Server.URLEncode(idStr)
        For i = 0 To UBound(fields)
            key = fields(i)
            val = Request.Form(key)
            body = body & "&" & key & "=" & Server.URLEncode(val)
        Next
    ElseIf InStr(sqlUpper, "DELETE") > 0 Then
        op = "delete"
        idStr = Trim(Request.QueryString("ID"))
        If idStr = "" Then idStr = Trim(Request.Form("ID"))
        If idStr = "" Then
            pos1 = InStr(sql, "=")
            If pos1 > 0 Then idStr = Trim(Mid(sql, pos1 + 1))
        End If
        body = "&ID=" & Server.URLEncode(idStr)
    ElseIf InStr(sqlUpper, "INSERT") > 0 Then
        op = "insert"
        body = ""
        For i = 0 To UBound(fields)
            key = fields(i)
            val = Request.Form(key)
            body = body & "&" & key & "=" & Server.URLEncode(val)
        Next
    Else
        Exit Sub
    End If

    Dim http
    Set http = Server.CreateObject("MSXML2.ServerXMLHTTP")
    http.Open "POST", "http://jsp:8081/agenda", False
    http.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
    http.Send "op=" & Server.URLEncode(op) & body
End Sub
%>
