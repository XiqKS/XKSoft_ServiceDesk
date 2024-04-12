<%
Response.ContentType = "text/javascript"

Dim apiBaseUrl

' Check if the session variable is already set
If IsEmpty(Session("APIBaseUrl"))Then
    ' Fetch from API or set defaults
    apiBaseUrl = ""
Else
    apiBaseUrl = Session("APIBaseUrl")
End If
%>

var apiBaseUrl = '<%= apiBaseUrl %>';