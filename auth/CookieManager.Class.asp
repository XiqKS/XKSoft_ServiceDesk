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

    Public Sub GenerateCSRFToken()
        ' Check if a CSRF token already exists in the session; generate one if it doesn't
        If IsEmpty(Session("CSRFToken")) Then
            Dim temp: temp = GenerateAuthString(32)
            Session("CSRFToken") = temp ' Store the new token in the session
            SetSecureCookie "CSRFToken", temp, 1 ' Set the cookie
        Else
            ' If a CSRF token already exists, just update the cookie with the existing token
            SetSecureCookie "CSRFToken", Session("CSRFToken"), 1
        End If
    End Sub

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