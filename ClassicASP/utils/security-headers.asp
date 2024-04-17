<%
    ' Check if the session variables are already set
    If IsEmpty(Session("APIBaseUrl")) Or IsEmpty(Session("DBConnectionString")) Then
        
        ' Retrieve environment variables directly instead of using an API call
        Session("DBConnectionString") = CreateObject("WScript.Shell").ExpandEnvironmentStrings("%DBConnectionString%")
        Session("APIBaseUrl") = CreateObject("WScript.Shell").ExpandEnvironmentStrings("%APIBaseUrl%")
        
        If Len(Session("DBConnectionString")) = 0 Or Len(Session("APIBaseUrl")) = 0 Then
            ' Handle the case where environment variables are not set
            Response.Write("Error: Required configuration is missing.")
        End If
    End If

    ' Add our api url to the connect-src of our CSP
    Dim cspValue
    cspValue = "default-src 'self'; script-src 'self'; style-src 'self'; connect-src 'self' " & Session("APIBaseUrl") & ";"
    Response.AddHeader "Content-Security-Policy", cspValue

    Response.AddHeader "X-Content-Type-Options", "nosniff"
    Response.AddHeader "X-Frame-Options", "DENY"
    Response.AddHeader "X-XSS-Protection", "1; mode=block"
    Response.AddHeader "Strict-Transport-Security", "max-age=31536000; includeSubDomains; preload"
    Response.AddHeader "Referrer-Policy", "strict-origin-when-cross-origin"
%>
