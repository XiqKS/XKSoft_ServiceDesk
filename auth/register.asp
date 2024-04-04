<%@ Language=VBScript %>
<!--#include file="CookieManager.Class.asp"-->
<%
    dim csrfToken, cookieSetter: set cookieSetter = new CookieManager
    csrfToken = cookieSetter.GenerateCSRFToken
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
    <meta name="csrf-token" content="<%=csrfToken%>">
</head>
<body>
    <div class="main-container container">
        <!--#include virtual="/dark-mode/dark-mode.asp" -->
        <img src="../icons/helldivers2.svg" class="top-left-icon" alt="Helldivers2 Icon">
        <div class="main-content">
            <h1>XKSoft ServiceDesk</h1>
            <h2>Register</h2>
            <input type="text" class="buttonEvents" id="username-field" name="username" placeholder="Username" required tabindex="1">
            <input type="password" class="buttonEvents hideField" id="password-field" name="password" placeholder="Password" required tabindex="2">
            <div class="relative-container">
                <div id="password-requirements" class="hideField">
                    <p>Password must contain:</p>
                    <ul>
                        <li id="req-length" class="invalid"><span class="symbol">✗</span> At least 8 characters</li>
                        <li id="req-number" class="invalid"><span class="symbol">✗</span> At least one number</li>
                        <li id="req-uppercase" class="invalid"><span class="symbol">✗</span> At least one uppercase letter</li>
                        <li id="req-lowercase" class="invalid"><span class="symbol">✗</span> At least one lowercase letter</li>
                        <li id="req-special" class="invalid"><span class="symbol">✗</span> At least one special character</li>
                        <br>
                        <li id="req-match" class="invalid"><span class="symbol">✗</span> Passwords match</li>
                    </ul>
                </div>
            </div>
            <input type="password" class="buttonEvents hideField" id="passwordConfirm-field" name="passwordConfirm" placeholder="Confirm Password" required tabindex="3">
            <div class="error-message" id="errorMessageRegister"></div>
        </div>
        <button type="button" class="next-button" onclick="chooseProcess()" tabindex="5">Next</button>
        <div class="login-link">    
            <p>Already registered? <a href="login.asp" tabindex="4">Login</a> now!</p>
        </div>
    </div>
    <div id="loadingBar" class="hideField">Loading...</div>

    
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
            if (input.name === 'password' || input.name === 'passwordConfirm') {
                input.addEventListener('keyup', updateRequirementStatus);
                
                const requirementsContainer = document.getElementById('password-requirements');
                input.addEventListener('focus', () => {
                    requirementsContainer.classList.remove('hideField'); // Show
                });
                input.addEventListener('blur', () => {
                    requirementsContainer.classList.add('hideField'); // Hide when not focused
                });
            }
        });

        function updateRequirementStatus() {
            const password = document.getElementById('password-field').value;
            const passwordConfirm = document.getElementById('passwordConfirm-field').value;

            const lengthRequirement = document.getElementById('req-length');
            const lengthSymbol = lengthRequirement.querySelector('.symbol');
            if (checkPasswordLength(password)) {
                lengthSymbol.textContent = '\u2713'; // Checkmark
                lengthRequirement.classList.add('valid');
                lengthRequirement.classList.remove('invalid');
            } else {
                lengthSymbol.textContent = '\u2717'; // Cross
                lengthRequirement.classList.add('invalid');
                lengthRequirement.classList.remove('valid');
            }

            const upperCaseRequirement = document.getElementById('req-uppercase');
            const upperCaseSymbol = upperCaseRequirement.querySelector('.symbol');
            if (checkPasswordUpperCase(password)) {
                upperCaseSymbol.textContent = '\u2713'; // Checkmark
                upperCaseRequirement.classList.add('valid');
                upperCaseRequirement.classList.remove('invalid');
            } else {
                upperCaseSymbol.textContent = '\u2717'; // Cross
                upperCaseRequirement.classList.add('invalid');
                upperCaseRequirement.classList.remove('valid');
            }

            const lowerCaseRequirement = document.getElementById('req-lowercase');
            const lowerCaseSymbol = lowerCaseRequirement.querySelector('.symbol');
            if (checkPasswordLowerCase(password)) {
                lowerCaseSymbol.textContent = '\u2713'; // Checkmark
                lowerCaseRequirement.classList.add('valid');
                lowerCaseRequirement.classList.remove('invalid');
            } else {
                lowerCaseSymbol.textContent = '\u2717'; // Cross
                lowerCaseRequirement.classList.add('invalid');
                lowerCaseRequirement.classList.remove('valid');
            }


            const digitRequirement = document.getElementById('req-number');
            const digitSymbol = digitRequirement.querySelector('.symbol');
            if (checkPasswordDigit(password)) {
                digitSymbol.textContent = '\u2713'; // Checkmark
                digitRequirement.classList.add('valid');
                digitRequirement.classList.remove('invalid');
            } else {
                digitSymbol.textContent = '\u2717'; // Cross
                digitRequirement.classList.add('invalid');
                digitRequirement.classList.remove('valid');
            }
            
            const symbolRequirement = document.getElementById('req-special');
            const symbol = symbolRequirement.querySelector('.symbol');
            if (checkPasswordSymbol(password)) {
                symbol.textContent = '\u2713'; // Checkmark
                symbolRequirement.classList.add('valid');
                symbolRequirement.classList.remove('invalid');
            } else {
                symbol.textContent = '\u2717'; // Cross
                symbolRequirement.classList.add('invalid');
                symbolRequirement.classList.remove('valid');
            }

            const matchRequirement = document.getElementById('req-match');
            const matchSymbol = matchRequirement.querySelector('.symbol');
            if (passwordConfirm === password && password !== '') {
                matchSymbol.textContent = '\u2713'; // Checkmark
                matchRequirement.classList.add('valid');
                matchRequirement.classList.remove('invalid');
            } else {
                matchSymbol.textContent = '\u2717'; // Cross
                matchRequirement.classList.add('invalid');
                matchRequirement.classList.remove('valid');
            }
        }

        function chooseProcess() {
            const username = document.getElementById('username-field').value.trim();
            const password = document.getElementById('password-field').value.trim();
            const passwordConfirm = document.getElementById('passwordConfirm-field').value.trim();
            
            if (validUsername(username)) 
                checkUsernameAvailability(username);
            
            if (!document.getElementById('password-field').classList.contains('hideField')) {
                if (validPassword(password,passwordConfirm)) 
                    registerUser(username,password);
                }
        }

        function validUsername(username) {
            if (username === '') {
                hidePasswordFields();
                changeErrorMessage('Please enter a username.');
            } else if (!checkUsername(username)) {
                hidePasswordFields();
                changeErrorMessage('Username is not valid');
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
            const passwordField = document.getElementById('password-field');
            const passwordConfirmField = document.getElementById('passwordConfirm-field');

            passwordField.classList.remove('hideField');
            passwordConfirmField.classList.remove('hideField');
        }

        function hidePasswordFields() {
            const passwordField = document.getElementById('password-field');
            const passwordConfirmField = document.getElementById('passwordConfirm-field');

            passwordField.classList.add('hideField');
            passwordConfirmField.classList.add('hideField');
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
