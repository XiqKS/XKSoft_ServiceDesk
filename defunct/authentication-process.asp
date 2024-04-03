<%@ Language=VBScript %>
<!--#include file="Crypto.Class.asp" -->

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
    Response.Write "Connection successful!<br>"
Else
    Response.Write "Failed to connect to the database."
End If

Dim username, password
username = Replace(Request.Form("username"), "'", "''")
password = Replace(Request.Form("password"), "'", "''")

If username <> "" And password <> "" Then
    Set crypt = New Crypto

    Dim cmd
    Dim cmdText 
    cmdText = "SELECT PasswordHash FROM Users WHERE Username = '" & username & "'"
    Set cmd = Server.CreateObject("ADODB.Command")
    
    cmd.ActiveConnection = conn
    
    ' Retrieve the hashed password from the database
    Dim storedPassword
    Dim rs
    Set rs = conn.Execute(cmdText)
    If Not rs.EOF Then
        storedPassword = rs("PasswordHash")
        ' Verify the user-provided password
        Dim isAuthenticated
        isAuthenticated = crypt.verifyPassword(password,storedPassword)
        
        If isAuthenticated Then
            ' Authentication successful, redirect the user to their dashboard
            Response.Redirect "../dashboard/dashboard.asp"
        Else
            ' Authentication failed
            Response.Write "Incorrect username or password"
        End If
    Else
        ' User not found
        Response.Write "User not found"
    End If
    
    ' Clean up
    rs.Close
    Set rs = Nothing
    Set cmd = Nothing
Else
    ' Username or password is empty
    Response.Write "Please provide both username and password"
End If
%>
