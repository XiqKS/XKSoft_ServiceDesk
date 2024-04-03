<%@ Language=VBScript %>
<%
' Include your database connection code or function here
Dim conn
Set conn = Server.CreateObject("ADODB.Connection")
Dim connStr
connStr = "REMOVED"
conn.ConnectionString = connStr
conn.Open


' Check if connection is open
If conn.State = 1 Then
    Response.Write "Connection successful!"
Else
    Response.Write "Failed to connect to the database."
End If
' Check if the form is submitted
If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
    ' Retrieve the username from the request
    Dim username
    username = SanitizeInput(Request.Form("username"))
    
    ' Check if the username exists in the database
    If IsUsernameAvailable(username) Then
        ' Username is available
        Response.Write "{ ""message"": ""Username is available"" }"
    Else
        ' Username is not available
        Response.Write "{ ""message"": ""Username is already taken"" }"
    End If
End If

' Function to check if the username is available
Function IsUsernameAvailable(username)
    ' Perform database query to check if the username exists
    ' Example query using ADO:
    Dim conn, rs
    Set conn = Server.CreateObject("ADODB.Connection")
    conn.Open "connection_string_here"
    Dim sql
    sql = "SELECT * FROM Users WHERE Username = '" & username & "'"
    Set rs = conn.Execute(sql)
    If rs.EOF Then
        IsUsernameAvailable = True
    Else
        IsUsernameAvailable = False
    End If
    rs.Close
    conn.Close

    ' For demonstration purposes, return True if username is not found
    ' Replace this with actual database logic
    IsUsernameAvailable = True
End Function

' Function to sanitize input data
Function SanitizeInput(input)
    ' Perform input sanitization to prevent SQL injection and other attacks
    ' Example: remove any potentially harmful characters
    SanitizeInput = Replace(input, "'", "''")
End Function
%>
