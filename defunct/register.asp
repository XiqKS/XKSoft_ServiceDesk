<%@ Language=VBScript %>
<!DOCTYPE html>
<html lang="en-US">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register</title>

    <link rel="stylesheet" href="../styles/login-styles.css">
    <!--#include virtual="/dark-mode/dark-mode.asp" -->
</head>
<body>
    <div class="container">

        <h1>Thank you for joining Claims Management System</h1>
        <p>Register below:</p>

        <form id="registerForm" action="#" method="post">

            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" class="button-events" id="input-username" name="username" required onkeypress="handleKeyPress(event)">
            </div>

            <div class="error-message" id="errorMessage-username"></div>

            <div id="passwordField" class="form-group" style="display: none;">
                <label for="password">Password:</label>
                <input type="password" class="button-events" id="input-password" name="password" required onkeypress="handleKeyPress(event)">
            </div>

            <div id="passwordConfirmField" class="form-group" style="display: none;">
                <label for="password">Confirm Password:</label>
                <input type="password" class="button-events" id="input-passwordConfirm" name="passwordConfirm" required onkeypress="handleKeyPress(event)">
            </div>

            <div class="error-message" id="errorMessage-password"></div>

            <div class="form-group">
                <button type="button" class="register-btn" onclick="chooseProcess()">Check For Username</button>
            </div>
        </form>
        <div class="login-container">    
            <p>Already registered? <a href="login.asp">Login</a> now!</p>
        </div>
        
    </div>
    <script>
        import { CleanInput } from './CleanInput.js';
        function usernameValidation() {
            const username = document.getElementById('input-username').value.trim();
            
            if (!checkUsernameField())
                return false;

            checkUsernameAvailability(username, function(isAvailable) {
                if (isAvailable) {
                    return true;
                }
            })
        }


        function handleKeyPress(event) {
            if (event.keyCode === 13) {
                chooseProcess();
            }
        } 

        function showPasswordFields() {
            document.getElementById('passwordField').style.display = 'block';
            document.getElementById('passwordConfirmField').style.display = 'block';
            document.querySelector('.register-btn').innerText = 'Register';
        }   

        function hidePasswordFields() {
            document.getElementById('passwordField').style.display = 'none';
            document.getElementById('passwordConfirmField').style.display = 'none';
            document.querySelector('.register-btn').innerText = 'Check For Username';
            changeErrorMessage('errorMessage-password','');
        }

        function checkUsernameField() {
            if (document.getElementById('input-username').value.trim() === '') {
                hidePasswordFields();
                changeErrorMessage('errorMessage-username','Please enter a username.');
                return false;
            }
            changeErrorMessage('errorMessage-username','');
            return true;
        }

        function checkPasswordFields() {
            if (document.getElementById('input-password').value.trim() === '')
                changeErrorMessage('errorMessage-password','Password cannot be empty');
            else if ((document.getElementById('input-password').value.trim() !== document.getElementById('input-passwordConfirm').value.trim()))
                changeErrorMessage('errorMessage-password','Password\'s do not match.');
            else {
                changeErrorMessage('errorMessage-password','');
                return true;
            }
            return false;
        }

        function changeErrorMessage(elementID, text) {
            document.getElementById(elementID).innerText = text;
        }

        function checkUsernameAvailability(username, callback) {
            const xhr = new XMLHttpRequest();
            xhr.open('POST', 'ajax-endpoint.asp', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        const response = JSON.parse(xhr.responseText);
                        if (!response.success) {
                            showPasswordFields();
                            callback(true);
                        } else {
                            hidePasswordFields();
                            changeErrorMessage('errorMessage-username','Username not available'); // Display error message
                            callback(false);
                        }
                    } else {
                        // Handle server error
                        changeErrorMessage('errorMessage-username','Error communicating with server'); // Display error message
                        callback(false);
                    }
                }
            };
            xhr.send('operation=usernameExists&username=' + encodeURIComponent(username));
        }

        function registerUser(username,password) {
            const xhr = new XMLHttpRequest();
            xhr.open('POST', 'ajax-endpoint.asp', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        const response = JSON.parse(xhr.responseText);
                        if (response.success) {
                            window.location.href = "login.asp?registered=true";
                        } else {
                            changeErrorMessage('errorMessage-password','Error registering user.');
                        }
                    } else {
                        changeErrorMessage('errorMessage-password','Error communicating with server.');
                    }
                }
            }
            xhr.send('operation=register&username=' + encodeURIComponent(username) + '&password=' + encodeURIComponent(password));                
        }
        
    </script>
</body>
</html>
