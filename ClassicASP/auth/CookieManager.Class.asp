<%
Class CookieManager
    Public Sub SetSecureCookie(name, value, days)
        Dim expireDate
        expireDate = DateAdd("d", days, Now())

        Dim cookieValue
        cookieValue = name & "=" & value & "; expires=" & expireDate & "; Path=/; Secure; HttpOnly; SameSite=Strict"

        ' Use the AddHeader method to set the Set-Cookie header with attributes
        Response.AddHeader "Set-Cookie", cookieValue
    End Sub

        ' For setting the cookie and managing a session variable
    Public Sub SetSecureCookieAndSession(name, value, days, sessionVarName)
        Dim expireDate
        expireDate = DateAdd("d", days, Now())

        Dim cookieValue
        cookieValue = name & "=" & value & "; expires=" & expireDate & "; Path=/; Secure; HttpOnly; SameSite=Strict"

        Session(sessionVarName) = value
    End Sub

    Public Function GenerateCSRFToken()
        ' Check if a CSRF token already exists in the session; generate one if it doesn't
        If IsEmpty(Session("CSRFToken")) Then
            Dim temp: temp = GenerateAuthString(32)
            Session("CSRFToken") = temp ' Store the new token in the session
            SetSecureCookie "CSRFToken", temp, 1 ' Set the cookie
        Else
            ' If a CSRF token already exists, just update the cookie with the existing token
            SetSecureCookie "CSRFToken", Session("CSRFToken"), 1
        End If
        GenerateCSRFToken = Session("CSRFToken")
    End Function

    ' New method to forcibly generate a new CSRF token
    Public Function RegenerateCSRFToken()
        Dim newToken
        newToken = GenerateAuthString(32) ' Call your method to generate a random string
        Session("CSRFToken") = newToken ' Override any existing CSRF token in the session
        SetSecureCookie "CSRFToken", newToken, 1 ' Set the new CSRF token as a secure cookie
        RegenerateCSRFToken = newToken ' Return the new token
    End Function

    function GenerateAuthString(length)
        Randomize Timer ' Initialize random number generator with current time

        Dim chars
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

        Dim randomString
        randomString = ""

        Dim i
        For i = 1 To length
            randomString = randomString & Mid(chars, Int(Rnd() * Len(chars)) + 1, 1)
        Next
        
        GenerateAuthString = randomString
    End Function

End Class
%>