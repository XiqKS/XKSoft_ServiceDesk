<%@ Language=VBScript %>
<!--#include file="CookieManager.Class.asp"-->
<%
    dim cookieSetter: set cookieSetter = new CookieManager
    cookieSetter.GenerateCSRFToken
    set cookieSetter = nothing
%>
<!DOCTYPE html>
<html lang="en-US">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register</title>

    <script src="../scripts/inputPolicy.js"></script>
    <link rel="stylesheet" href="../styles/login-styles.css">
</head>
<body>
    <div class="main-container container">
        <!--#include virtual="/dark-mode/dark-mode.asp" -->
        <img src="../icons/helldivers2.svg" class="top-left-icon" alt="Helldivers2 Icon">
        <div class="main-content">
            <h1>XKSoft ServiceDesk</h1>
            <input type="text" class="buttonEvents" id="username-field" name="username" placeholder="Username" required tabindex="1">
            <input type="password" class="buttonEvents hideField" id="password-field" name="password" placeholder="Password" required tabindex="2">
            <div class="error-message" id="errorMessageLogin"></div>
        </div>
        <button type="button" class="next-button" onclick="chooseProcess()" tabindex="5">Next</button>
        <div class="login-link">    
            <p>Don't have an account? <a href="login.asp" tabindex="4">Register</a> now!</p>
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
                hidePasswordFields();
                changeErrorMessage('Please enter a username');
            } else if (!checkUsername(username)) {
                hidePasswordFields();
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

        function showPasswordFields() {
            const passwordField = document.getElementById('password-field');
            passwordField.classList.remove('hideField');
        }

        function hidePasswordFields() {
            const passwordField = document.getElementById('password-field');
            passwordField.classList.add('hideField');
        }

        function changeErrorMessage(text) {
            document.getElementById('errorMessageLogin').innerText = text;
        }

        function checkUsernameAvailability(username) {
            const xhr = new XMLHttpRequest();
            xhr.open('POST', 'ajax-endpoint.asp', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        const response = JSON.parse(xhr.responseText);
                        if (response.success) {
                            showPasswordFields();
                        } else {
                            changeErrorMessage('Username not found'); // Display error message
                        }
                    } else {
                        changeErrorMessage('Error communicating with server'); // Display error message
                    }
                }
            };
            xhr.send('operation=usernameExists&username=' + encodeURIComponent(username));
        }

        function authenticateUser(username,password) {

            const xhr = new XMLHttpRequest();
            xhr.open('POST', 'ajax-endpoint.asp', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        const response = JSON.parse(xhr.responseText);
                        if (response.success) {
                            window.location.href = "../dashboard/dashboard.asp";
                        } else {
                            changeErrorMessage('Error logging in user.');
                        }
                    } else {
                        changeErrorMessage('Error communicating with server');
                    }
                }   
            }
            xhr.send('operation=authenticate&username=' + encodeURIComponent(username) + '&password=' + encodeURIComponent(password));                
        }
    </script>   
</body>
</html>
