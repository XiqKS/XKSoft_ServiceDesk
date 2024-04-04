<%@ Language=VBScript %>
<!DOCTYPE html>
<html>
<head>
</head>
<body>
<%
' Define connection string
Dim connStr
connStr = "REMOVED"

' Create connection object
Dim conn
Set conn = Server.CreateObject("ADODB.Connection")

' Open connection
On Error Resume Next
conn.Open connStr
If Err.Number <> 0 Then
    Response.Write "Failed to connect to the database. Error: " & Err.Description
Else
    If conn.State = 1 Then
        Response.Write "Connection successful!"
    Else
        Response.Write "Failed to connect to the database."
    End If
End If
On Error Goto 0

' Close connection
If Not conn Is Nothing Then
    If conn.State = 1 Then
        conn.Close
    End If
    Set conn = Nothing
End If
%>
</body>
</html>
