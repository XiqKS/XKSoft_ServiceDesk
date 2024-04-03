<%
Dim csrfToken, cookieValue

' Check if a CSRF token already exists in the session; generate one if it doesn't
If IsEmpty(Session("CSRFToken")) Then
    csrfToken = GenerateAuthToken(32) ' Generate a new token only if needed
    Session("CSRFToken") = csrfToken ' Store the new token in the session
Else
    csrfToken = Session("CSRFToken") ' Use the existing token from the session
End If

' Prepare the cookie value with the CSRF token
cookieValue = "CSRFToken=" & csrfToken & "; Secure; HttpOnly; SameSite=Strict"

' Use the AddHeader method to set the Set-Cookie header
Response.AddHeader "Set-Cookie", cookieValue
' No need for redirect in this context unless you have a specific reason for it


function GenerateAuthToken(length)
    Randomize Timer ' Initialize random number generator with current time

    Dim chars
    chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

    Dim randomString
    randomString = ""

    Dim i
    For i = 1 To length
        randomString = randomString & Mid(chars, Int(Rnd() * Len(chars)) + 1, 1)
    Next
    
    GenerateAuthToken = randomString
End Function


%>
