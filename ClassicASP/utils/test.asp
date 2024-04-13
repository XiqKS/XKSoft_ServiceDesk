<!-- test.asp -->
<html>
<head>
    <title>Test Configuration Page</title>
    <script type="text/javascript">
        function fetchConfig() {
            var xhr = new XMLHttpRequest();
            xhr.open("GET", "https://xksoft-servicedesk-api.azurewebsites.net/api/config/settings", true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState == 4 && xhr.status == 200) {
                    // Assuming the response is in JSON format
                    var config = JSON.parse(xhr.responseText);
                    document.getElementById("dbConnectionString").innerText = "DB Connection String: " + config.DatabaseConnectionString;
                    document.getElementById("apiBaseUrl").innerText = "API Base URL: " + config.ApiBaseUrl;
                } else if (xhr.readyState == 4) {
                    document.getElementById("dbConnectionString").innerText = "Failed to fetch configuration: " + xhr.statusText;
                    document.getElementById("apiBaseUrl").innerText = "Status Code: " + xhr.status;
                }
            };
            xhr.send();
        }

        window.onload = fetchConfig; // Fetch configuration when the page loads
    </script>
</head>
<body>
    <h1>Configuration Test Page</h1>
    <p id="dbConnectionString">Loading database connection string...</p>
    <p id="apiBaseUrl">Loading API base URL...</p>
</body>
</html>
