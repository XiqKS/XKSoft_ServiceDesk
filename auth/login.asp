<%@ Language=VBScript %>
<!--#include file="CookieManager.Class.asp"-->
<%
    dim cookieSetter: set cookieSetter = new CookieManager
    csrfToken = cookieSetter.GenerateCSRFToken
    set cookieSetter = nothing
%>
<!DOCTYPE html>
<html lang="en-US">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    
    <script src="../scripts/inputPolicy.js"></script>
    <link rel="stylesheet" href="../styles/login-styles.css">
    <meta name="csrf-token" content="<%=csrfToken%>">
</head>
<body>
    <div class="main-container container">
        <!--#include virtual="/dark-mode/dark-mode.asp" -->
        <img src="../icons/helldivers2.svg" class="top-left-icon" alt="Helldivers2 Icon">
        <div class="main-content">
            <h1>XKSoft ServiceDesk</h1>
            <h2>Login</h2>
            <input type="text" class="buttonEvents" id="username-field" name="username" placeholder="Username" required tabindex="1">
            <input type="password" class="buttonEvents hideField" id="password-field" name="password" placeholder="Password" required tabindex="2">
            <div class="error-message" id="errorMessageLogin"></div>
        </div>
        <button type="button" class="next-button" onclick="chooseProcess()" tabindex="5">Next</button>
        <div class="login-link">    
            <p>Don't have an account? <a href="register.asp" tabindex="4">Register</a> now!</p>
        </div>
        <div class="loading-bar-wrapper">
            <div id="loadingBar" class="hideField"></div>
        </div>
    </div>
    
    <script>
        // Event handler for keypress on input fields
        document.querySelectorAll('.buttonEvents').forEach(function(input) {
            input.addEventListener('keypress', function(event) {
                if (event.key === 'Enter') {
                    chooseProcess();
                } else if ((event.target.id == 'username-field') && (!isValidUsernameCharacter(event.key))) {
                    event.preventDefault();
                } else if (((event.target.id == 'password-field') || (event.target.id == 'passwordConfirm-field')) && (!isValidPasswordCharacter(event.key))) {
                    event.preventDefault();
                }
            });
        });

        function chooseProcess() {
            const username = document.getElementById('username-field').value.trim();
            const password = document.getElementById('password-field').value.trim();
            if (validUsername(username)) 
                checkUsernameAvailability(username);
            
            if (!document.getElementById('password-field').classList.contains('hideField')) 
                if (validPassword(password))
                    authenticateUser(username,password);
        }

        function validUsername(username) {
            if (username === '') {
                togglePasswordFields(false);
                changeErrorMessage('Please enter a username');
            } else if (!checkUsername(username)) {
                togglePasswordFields(false);
                changeErrorMessage('Username is not valid');
            } else {
                changeErrorMessage('');
                return true;
            }
            return false;
        }

        function validPassword(password) {
            if (password === '')
                changeErrorMessage('Password cannot be empty');
            else if (!checkPassword(password))
                changeErrorMessage('Password does not meet the required complexity');
            else {
                changeErrorMessage('');
                return true;
            }
            return false;
        }

        function togglePasswordFields(show) {
            const passwordField = document.getElementById('password-field');
            show ? passwordField.classList.remove('hideField') : passwordField.classList.add('hideField');
        }

        function changeErrorMessage(text) {
            document.getElementById('errorMessageLogin').innerText = text;
        }

        // Define a function to handle showing and hiding the loading bar
        function toggleLoadingBar(show) {
            const loadingBar = document.getElementById('loadingBar');
            if (show) {
                loadingBar.classList.remove('hideField');
            } else {
                loadingBar.classList.add('hideField');
            }
        }

        async function checkUsernameAvailability(username) {
            const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
            toggleLoadingBar(true); // Show loading bar 

            try {
                const response = await fetch('ajax-endpoint.asp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: `operation=usernameExists&username=${encodeURIComponent(username)}&csrfToken=${encodeURIComponent(csrfToken)}`
                });
                const data = await response.json();
                await delay(500);
                toggleLoadingBar(false); // Hide loading bar after request

                if (data.success) {
                    togglePasswordFields(true);
                } else {
                    changeErrorMessage('Username not available.');
                }
            } catch (error) {
                console.error('Error:', error);
                toggleLoadingBar(false); // Hide loading bar on error
                changeErrorMessage('Error communicating with server.');
            }
        }

        async function authenticateUser(username, password) {
            const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
            toggleLoadingBar(true); // Show loading bar

            try {
                const response = await fetch('ajax-endpoint.asp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                    body: `operation=authenticate&username=${encodeURIComponent(username)}&password=${encodeURIComponent(password)}&csrfToken=${encodeURIComponent(csrfToken)}`
                });
                const data = await response.json();
                await delay(500);
                toggleLoadingBar(false); // Hide loading bar after request

                if (data.success) {
                    window.location.href = "../dashboard/dashboard.asp"; // Adjust the redirect URL as needed
                } else {
                    changeErrorMessage('Error logging in user.');
                }
            } catch (error) {
                console.error('Error:', error);
                toggleLoadingBar(false); // Hide loading bar on error
                changeErrorMessage('Error communicating with server.');
            }
        }

        function delay(ms) {
            return new Promise(resolve => setTimeout(resolve, ms));
        }
    </script>   

</body>
</html>
