<%@ Language=VBScript %>
<!--#include virtual="/auth/CookieManager.Class.asp" -->
<%
' Check for user authentication; redirect if not authenticated
If Session("LoggedInUser") = "" Then
    Response.redirect("../auth/login.asp")
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
    <nav class="navbar">
        <ul>
            <li><a href="/dashboard/dashboard.asp">Home</a></li>
            <li><a href="/tickets/create.asp">Create Ticket</a></li>
            <li><a href="/tickets/view.asp">View Tickets</a></li>
            <li><a href="/auth/logout.asp">Logout</a></li>
        </ul>
    </nav>
    <h1>Welcome, <%=userName%>!</h1>
    <div id="ticketOverview">
        <!-- Tickets Overview Will Be Injected Here -->
    </div>
    <script src="../scripts/dashboard.js"></script>
</body>
</html>
