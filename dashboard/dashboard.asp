<%@ Language=VBScript %>
<!--#include file="../auth/CookieManager.Class.asp"-->
<%
' Check for user authentication; redirect if not authenticated
If Session("LoggedInUser") = "" Then
    Response.Redirect("login.asp")
End If

' User-specific content goes here
dim userName: userName = Session("LoggedInUser")
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Dashboard</title>
    <link rel="stylesheet" href="../styles/dashboard-styles.css">
    <!-- Additional meta tags or scripts here -->
</head>
<body>
    <h1>Welcome, <%=userName%>!</h1>
    <div id="ticketOverview">
        <!-- Tickets Overview Will Be Injected Here -->
    </div>
    <script src="../scripts/dashboard.js"></script>
</body>
</html>
