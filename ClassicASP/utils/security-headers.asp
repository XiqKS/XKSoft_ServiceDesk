<!--#include file="aspDevelopmentVars.asp"-->
<%
    ' Check if the session variables are already set
    If IsEmpty(Session("APIBaseUrl")) Or IsEmpty(Session("DBConnectionString")) Then
        Dim http, apiUrl
        Set http = CreateObject("MSXML2.ServerXMLHTTP")
        apiUrl = "https://xksoft-servicedesk-api.azurewebsites.net/config/settings"

        ' Sending the request
        Call http.Open("GET", apiUrl, False)
        Call http.Send()

        If http.Status = 200 Then
            ' Parse JSON here (this example assumes you have a JSON parser or handle it manually)
            ' For demonstration, let's assume the API returns simple delimited data
            Dim settings
            settings = Split(http.responseText, ";") ' Very simplistic parsing logic

            ' Store in session variables
            Session("DBConnectionString") = settings(0)
            Session("APIBaseUrl") = settings(1)
        Else
            ' Handle errors or log them
            Response.Write("Error fetching configuration: " & http.Status)
        End If

        Set http = Nothing
    End If

    Dim cspValue
    cspValue = "default-src 'self'; script-src 'self'; style-src 'self'; connect-src 'self' " & Session("APIBaseUrl") & ";"

    Response.AddHeader "Content-Security-Policy", cspValue
    Response.AddHeader "X-Content-Type-Options", "nosniff"
    Response.AddHeader "X-Frame-Options", "DENY"
    Response.AddHeader "X-XSS-Protection", "1; mode=block"
    Response.AddHeader "Strict-Transport-Security", "max-age=31536000; includeSubDomains; preload"
    Response.AddHeader "Referrer-Policy", "strict-origin-when-cross-origin"
%>
