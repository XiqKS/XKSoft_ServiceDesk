<%@ Language=VBScript %>
<!--#include file="CookieManager.Class.asp"-->
<%
If IsEmpty(Session("CSRFToken")) Then
    dim cookieSetter: set cookieSetter = new CookieManager
    cookieSetter.GenerateCSRFToken
End If
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

        <h1>XKSoft Solutions</h1>
        <input type="text" class="buttonEvents" id="username-field" name="username" placeholder="Username" required tabindex="1">
        <input type="password" class="buttonEvents hideField" id="password-field" name="password" required tabindex="2">
        <input type="password" class="buttonEvents hideField" id="passwordConfirm-field" name="passwordConfirm" required tabindex="3">
        <div class="error-message" id="errorMessageRegister"></div>

        <button type="button" class="next-button" onclick="chooseProcess()" tabindex="4">Next</button>
        <div class="login-link">    
            <p>Already registered? <a href="login.asp" tabindex="5">Login</a> now!</p>
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
            const passwordConfirm = document.getElementById('passwordConfirm-field').value.trim();
            
            if (validUsername(username)) 
                checkUsernameAvailability(username);
    
            if (document.getElementById('password-field').classList.contains('showField')) 
                if (validPassword(password,passwordConfirm)) 
                    registerUser(username,password);
        }

        function validUsername(username) {
            if (username === '') {
                hidePasswordFields();
                changeErrorMessage('Please enter a username.');
            } else if (!checkUsername(username)) {
                hidePasswordFields();
                changeErrorMessage('Invalid character in username.');
            } else {
                changeErrorMessage('');
                return true;
            }
            return false;
        }

        function validPassword(password, confirmPassword) {
            if (password === '')
                changeErrorMessage('Password cannot be empty');
            else if (password !== confirmPassword)
                changeErrorMessage('Password\'s do not match.');
            else if (!checkPassword(password))
                changeErrorMessage('Password does not meet the required complexity.');
            else {
                changeErrorMessage('');
                return true;
            }
            return false;
        }

        function showPasswordFields() {
            const usernameField = document.getElementById('username-field');
            const passwordField = document.getElementById('password-field');
            const passwordConfirmField = document.getElementById('passwordConfirm-field');

            passwordField.classList.add('showField');
            passwordConfirmField.classList.add('showField');
        }

        function hidePasswordFields() {
            const usernameField = document.getElementById('username-field');
            const passwordField = document.getElementById('password-field');
            const passwordConfirmField = document.getElementById('passwordConfirm-field');

            passwordField.classList.remove('showField');
            passwordConfirmField.classList.remove('showField');
        }

        function changeErrorMessage(text) {
            document.getElementById('errorMessageRegister').innerText = text;
        }

        function checkUsernameAvailability(username) {
            const xhr = new XMLHttpRequest();
            xhr.open('POST', 'ajax-endpoint.asp', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        const response = JSON.parse(xhr.responseText);
                        if (!response.success) {
                            showPasswordFields();
                        } else {
                            changeErrorMessage('Username not available'); // Display error message
                        }
                    } else {
                        changeErrorMessage('Error communicating with server'); // Display error message
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
                        alert(xhr.responseText);
                        const response = JSON.parse(xhr.responseText);
                        if (response.success) {
                            window.location.href = "login.asp?registered=true";
                        } else {
                            changeErrorMessage('Error registering user.');
                        }
                    } else {
                        changeErrorMessage('Error communicating with server.');
                    }
                }   
            }
            xhr.send('operation=register&username=' + encodeURIComponent(username) + '&password=' + encodeURIComponent(password));                
        }
    </script>   
</body>
</html>
