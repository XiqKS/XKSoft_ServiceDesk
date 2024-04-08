<!DOCTYPE html>
<html>
<head>
    <title>Tickets Dashboard</title>
    <link rel="stylesheet" href="../styles/ticket-styles.css">
    <link rel="stylesheet" href="/styles/dashboard-styles.css">
</head>
<body>
    <!--#include virtual="/dashboard/navbar/navbar.asp" -->
<h2>Tickets Dashboard</h2>
<div id="ticketsTable">
    <table>
        <thead>
            <tr>
                <th>Title</th>
                <th>Description</th>
                <th>Status</th>
                <th>Priority</th>
                <th>Creation Date</th>
            </tr>
        </thead>
        <tbody id="ticketsBody">
            <!-- Tickets will be inserted here by JavaScript -->
        </tbody>
    </table>
</div>

<script src="../scripts/dashboard/tickets.js"></script>

</body>
</html>
