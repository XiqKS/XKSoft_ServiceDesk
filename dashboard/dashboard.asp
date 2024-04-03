<%@ Language=VBScript %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Claims Management System</title>

    <link rel="stylesheet" href="../styles/global-styles.css">
</head>
<body>
    <div class="darkmode-toggle-container">
        <input type="checkbox" id="darkmode-toggle" class="darkmode-toggle-checkbox" onclick="toggleDarkMode()">
        <label for="darkmode-toggle" class="darkmode-toggle-label">
            <div class="darkmode-toggle-slider"></div>
        </label>
    </div>
    <div class="container">
        <h1>Welcome to Your Dashboard</h1>
        <p>This is where you can manage your claims.</p>
        <!-- Add your dashboard content here -->
    </div>
    <script>
        // Function to set a cookie with the specified name, value, and expiration date
        function setCookie(name, value, days) {
            var expires = "";
            if (days) {
                var date = new Date();
                date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
                expires = "; expires=" + date.toUTCString();
            }
            document.cookie = name + "=" + (value || "") + expires + "; path=/";
        }

        // Function to get the value of a cookie by its name
        function getCookie(name) {
            var nameEQ = name + "=";
            var cookies = document.cookie.split(';');
            for (var i = 0; i < cookies.length; i++) {
                var cookie = cookies[i];
                while (cookie.charAt(0) === ' ') {
                    cookie = cookie.substring(1, cookie.length);
                }
                if (cookie.indexOf(nameEQ) === 0) {
                    return cookie.substring(nameEQ.length, cookie.length);
                }
            }
            return null;
        }

        // Function to handle the click event of the dark mode switch
        function toggleDarkMode() {
            const body = document.body;
            body.classList.toggle('dark-mode');
            // Save the current state of dark mode to a cookie
            setCookie('darkModeEnabled', body.classList.contains('dark-mode') ? 'true' : 'false', 365);
        }

        // Function to initialize the dark mode switch based on the saved cookie value
        function initializeDarkMode() {
            const darkModeEnabled = getCookie('darkModeEnabled');
            const darkModeSwitch = document.getElementById('darkmode-toggle');
            if (darkModeEnabled === 'true') {
                // Dark mode is enabled, so toggle the class to activate it
                document.body.classList.add('dark-mode');
                darkModeSwitch.checked = true;
            }
        }

        // Initialize the dark mode switch when the page loads
        window.onload = initializeDarkMode;
    </script>
</body>
</html>
