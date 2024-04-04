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

    ' Hash the password before storing it in the database
    Dim hashedPassword
    set crypt = new crypto 
    hashedPassword = crypt.hashPassword(password, "SHA256", "hex")
    set crypt = nothing

    ' Assuming you have a database connection object named "conn"
    Dim cmdText
    cmdText = "INSERT INTO Users (Username, PasswordHash, Email, CreatedAt, UpdatedAt) VALUES ('" & username & "', '" & hashedPassword & "', '', GETDATE(), GETDATE())"
    
    ' Execute the query
    conn.Execute cmdText

    Response.Write "User registered successfully"
    
Else
    Response.Write "Please provide both username and password"
End If

' Clean up
conn.Close
Set conn = Nothing
%>
