<!--#include file="UserManager.Class.asp"-->
<%
    Dim submittedToken, sessionToken
    submittedToken = Request.Form("csrfToken") ' Get CSRF token from post
    sessionToken = Session("CSRFToken") ' CSRF token from session

    ' Check if the tokens match
    If submittedToken = "" OR submittedToken <> sessionToken Then
        Response.Write "{""success"": false, ""error"": ""CSRF token mismatch or missing.""}"
        Response.End
    End If

    ' Retrieve POST parameters
    Dim username: username = Request.Form("username")
    Dim password: password = Request.Form("password")
    Dim operation: operation = Request.Form("operation")

    ' Initialize UserManager class and InputPolicy class
    Dim manager: Set manager = New userManager

    ' Perform operation based on parameter
    Dim result
    Select Case operation
        Case "authenticate"
            scanUsername(username)
            scanPassword(password)
            result = manager.AuthenticateUser(username, password)
            If result Then
                Response.Write "{""success"": true}"
            Else
                Response.Write "{""success"": false}"
            End If
        Case "usernameExists"
            scanUsername(username)
            result = manager.UsernameExists(username)
            If result Then
                Response.Write "{""success"": true}"
            Else
                Response.Write "{""success"": false}"
            End If
        Case "register"
            scanUsername(username)
            scanPassword(password)
            result = manager.RegisterUser(username, password)
            If result Then
                Response.Write "{""success"": true}"
            Else
                Response.Write "{""success"": false}"
            End If
        Case Else
            Response.Write "{""error"": ""Invalid operation""}"
    End Select

    ' Clean up resources
    Set manager = Nothing

    sub scanUsername(User)
        dim scanner: Set scanner = New InputPolicy
        if (Not scanner.CheckUsername(User)) Then
            Response.Write "{""success"": false, ""error"": ""Invalid username.""}"
            set scanner = nothing
            Response.End
        End if
        set scanner = nothing
    End sub

    sub scanPassword(Pass)
        dim scanner: Set scanner = New InputPolicy
        if (Not scanner.CheckPassword(Pass)) Then
            Response.Write "{""success"": false, ""error"": ""Invalid password.""}"
            set scanner = nothing
            Response.End
        End if
        set scanner = nothing
    End sub
%>
