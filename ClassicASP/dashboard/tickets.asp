<%@ Language=VBScript %>
<!--#include virtual="/utils/security-headers.asp" -->
<!--#include virtual="/auth/CookieManager.Class.asp" -->
<%
' Check for user authentication; redirect if not authenticated
If Session("LoggedInUser") = "" Then
    Response.redirect("/auth/login.asp")
End If

dim userName: userName = Session("LoggedInUser")
%>

<!DOCTYPE html>
<html lang="en-US">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/styles/dashboard-styles.css">
</head>
<body>
    <!--#include virtual="/components/ticket-container/ticket-container.asp" -->
    <script src="/scripts/dashboard/tickets.js"></script>
</body>
</html>
