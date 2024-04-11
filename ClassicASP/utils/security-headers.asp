<%
    Dim apiUrl
    apiUrl = Server.GetEnviron("API_BASE_URL")

    Dim cspValue
    cspValue = "default-src 'self'; script-src 'self'; style-src 'self'; connect-src 'self' " & apiUrl & ";"

    Response.AddHeader "Content-Security-Policy", cspValue
    Response.AddHeader "X-Content-Type-Options", "nosniff"
    Response.AddHeader "X-Frame-Options", "DENY"
    Response.AddHeader "X-XSS-Protection", "1; mode=block"
    Response.AddHeader "Strict-Transport-Security", "max-age=31536000; includeSubDomains; preload"
    Response.AddHeader "Referrer-Policy", "strict-origin-when-cross-origin"
%>