<!--#include file="db-config.asp"-->
<!--#include file="Crypto.Class.asp"-->
<!--#include file="InputPolicy.Class.asp"-->
<!--#include file="CookieManager.Class.asp"-->

<%
'ADO constants
Const adVarChar = 200
Const adParamInput = 1
Const adCmdText = 1


Class userManager
    Private conn
    
    ' CONSTRUCTOR: Initializes the database connection
    Private Sub Class_Initialize()
        Set conn = Server.CreateObject("ADODB.Connection")
        conn.Open connStr

        Session.Timeout = 20
    
        ' Add security headers
        Response.AddHeader "Content-Security-Policy", "default-src 'self'; script-src 'self' ../scripts; style-src 'self' ../styles;"
        Response.AddHeader "X-Content-Type-Options", "nosniff"
        Response.AddHeader "X-Frame-Options", "DENY"
        Response.AddHeader "X-XSS-Protection", "1; mode=block"
        Response.AddHeader "Strict-Transport-Security", "max-age=31536000; includeSubDomains; preload"
        Response.AddHeader "Referrer-Policy", "strict-origin-when-cross-origin"
    End Sub
    
    public Function AuthenticateUser(User, Pass)
        On Error Resume Next
        AuthenticateUser = False

        if (Not ValidUsername(User)) Then
            Response.Write "Invalid username"
            Exit Function
        Elseif (Not ValidPassword(Pass)) Then
            Response.Write "Invalid password"
            Exit Function
        End If

        ' Initialize our cmdText, parameters, and the return rs. Then execute the query.
        Dim cmdText: cmdText = "SELECT PasswordHash FROM Users WHERE Username = ?;"
        Dim params(0): params(0) = Array("Username", User) 
        Dim rs: Set rs = ExecuteQuery(cmdText, params)
        HandleError "Error executing query"

        If Not rs.EOF Then
            ' Initialize our Crypto object and use its method to verify the user submitted password against the hash from the recordset
            Dim crypt: Set crypt = New Crypto
            If crypt.verifyPassword(Pass, rs("PasswordHash")) Then
                Dim cookieManager: Set cookieManager = New CookieManager
                Dim authToken: authToken = cookieManager.GenerateAuthString(32) ' Assuming you have a method for generating the auth token
                cookieManager.SetSecureCookie "AuthToken", authToken, 30 ' Set auth token for 30 days
                cookieManager.SetSecureCookie "LoggedInUser", User, 30 ' Set logged in username for 30 days
                Set cookieManager = nothing
                HandleError "Error initializing authorization cookies"

                set rs = nothing
                set crypt = nothing
                AuthenticateUser = true
                'Response.Redirect "../dashboard/dashboard.asp"
            Else
                Response.Write "Incorrect username or password"
            End If
        Else
            ' Make sure a user was found
            Response.Write "User not found"
        End If
        ' Cleaning
        set rs = nothing
        set crypt = nothing
        On Error GoTo 0
    End Function

    public Function UsernameExists(User)
        On Error Resume Next
        UsernameExists = false

        if (Not ValidUsername(User)) Then
            Response.Write "Invalid username"
            Exit Function
        End If

        Dim cmdText: cmdText = "SELECT COUNT(1) FROM Users WHERE Username = ?;"
        Dim params(0): params(0) = Array("Username", User) 
        dim rs: Set rs = ExecuteQuery(cmdText, params)

        If Not rs.EOF Then
            UsernameExists = rs(0) > 0
        End If
        
        ' Cleaning
        set rs = nothing
        On Error GoTo 0
    End Function

    public Function RegisterUser(User,Pass)
        On Error Resume Next
        RegisterUser = false

        if (Not ValidUsername(User)) Then
            Response.Write "Invalid username"
            Exit Function
        Elseif (Not ValidPassword(Pass)) Then
            Response.Write "Invalid password"
            Exit Function
        End If

        ' Check if the username exists in the database before registering it again
        if (UsernameExists(User)) Then
            Response.Write "Username already exists"   
            Exit Function 
        End If

        ' Initialize our crypto object
        Dim crypt: Set crypt = New Crypto
        HandleError "Error creating Crypto object"

        ' Hash the password
        Dim hashedPassword: hashedPassword = crypt.hashPasswordArgon2(Pass)
        set crypt = nothing
        HandleError "Error hashing password"

        ' Prep our sql statement and parameters
        Dim cmdText: cmdText = "INSERT INTO Users (Username, PasswordHash, Email, CreatedAt, UpdatedAt) VALUES (?, ?, '', GETDATE(), GETDATE());"
        Dim params(1)
        params(0) = Array("Username", User)
        params(1) = Array("PasswordHash", hashedPassword)
        
        RegisterUser = ExecuteNonQuery(cmdText,params)
        HandleError "Error executing SQL query"


        On Error GoTo 0
    End Function

    Private Function ExecuteQuery(query, params)
        On Error Resume Next

        ' Set up our command object
        Dim cmd: Set cmd = Server.CreateObject("ADODB.Command")
        Set cmd.ActiveConnection = conn
        cmd.CommandText = query
        cmd.CommandType = adCmdText

        ' Extract and append parameters into cmd
        Dim param, paramName, paramValue
        For Each param In params
            paramName = param(0)
            paramValue = param(1)
            cmd.Parameters.Append cmd.CreateParameter(paramName, adVarChar, adParamInput, Len(paramValue), paramValue)
            HandleError "Error creating parameter"
        Next

        ' Execute our query
        ExecuteQuery = cmd.Execute
        HandleError "Error executing query"

        On Error GoTo 0
    End Function

    
    Private Function ExecuteNonQuery(query, params)
        On Error Resume Next

        ' Initialize our command object
        Dim cmd: Set cmd = Server.CreateObject("ADODB.Command")
        Set cmd.ActiveConnection = conn
        cmd.CommandText = query
        cmd.CommandType = adCmdText

        ' Extract and append parameters into cmd
        Dim param, paramName, paramValue
        For Each param In params
            paramName = param(0)
            paramValue = param(1)
            cmd.Parameters.Append cmd.CreateParameter(paramName, adVarChar, adParamInput, Len(paramValue), paramValue)
            HandleError "Error creating parameter"
        Next

        ' Execute our statement and check for an error
        cmd.Execute
        If Err.Number <> 0 Then
            HandleError "Error executing non-query SQL statement"
            ExecuteNonQuery = False
        Else
            ExecuteNonQuery = True
        End If

        On Error GoTo 0
    End Function

    Private Function ValidUsername(username)
        Dim scanner: set scanner = new InputPolicy
        ValidUsername = scanner.CheckUsername(username)
        set scanner = nothing
    End Function

    Private Function ValidPassword(password)
        Dim scanner: set scanner = new InputPolicy
        ValidPassword = scanner.CheckPassword(password)
        set scanner = nothing
    End Function

    ' Handles erroring messaging
    private Sub HandleError(errorMessage)
        If Err.Number <> 0 Then
            Response.Write errorMessage & ": " & Err.Description
            Err.Clear
        End If
    End Sub

    ' DESTRUCTOR: Close conn and clean conn pointer
    Private Sub Class_Terminate()
        If Not conn Is Nothing Then
            conn.Close
            Set conn = Nothing
        End If
    End Sub
End Class
%>