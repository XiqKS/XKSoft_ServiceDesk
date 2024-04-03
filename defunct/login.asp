<%@ Language=VBScript %>
<!DOCTYPE html>
<html lang="en-US">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>

    <link rel="stylesheet" href="../styles/login-styles.css">
    <!--#include virtual="/dark-mode/dark-mode.asp" -->
</head>
<body>
    <div class="container" id="registered" style="display: none;">
        <h1>Thank you for registering for Claims Management Systems, please login below!</h1>
    </div>

    <div class="container">
        <h1>Welcome to the Claims Management Systems</h1>
        <p>This system allows you to submit and manage your claims efficiently.</p>

        <form id="loginForm" action="#" method="post">

            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" class="button-events" id="input-username" name="username" required onkeypress="handleKeyPress(event)">
            </div>

            <div class="error-message" id="errorMessage-username"></div>

            <div id="passwordField" class="form-group" style="display: none;">
                <label for="password">Password:</label>
                <input type="password" class="button-events" id="input-password" name="password" required onkeypress="handleKeyPress(event)">
            </div>

            <div class="error-message" id="errorMessage-password"></div>

            <div class="form-group">
                <button type="button" class="login-btn" onclick="nextStep()">Next</button>
            </div>
        </form>
        <div class="register-container">
            <p>Not registered? <a href="register.asp">Sign up</a> now!</p>
        </div>
        
    </div>
    <script>
        function handleKeyPress(event) {
            if (event.keyCode === 13) {
                nextStep();
            }
        }   

        function showPasswordField() {
            document.getElementById('passwordField').style.display = 'block';
            document.querySelector('.login-btn').setAttribute('onclick', 'submitUser(username.value.trim(),password.value.trim())');            
            document.querySelector('.button-events').setAttribute('onkeypress', 'submitUser(username.value.trim(),password.value.trim())');
        }   

        function hidePasswordField() {
            document.getElementById('passwordField').style.display = 'none';
            document.querySelector('.login-btn').setAttribute('onclick', 'nextStep()');
            document.querySelector('.button-events').setAttribute('onkeypress', 'nextStep()');
            changeErrorMessage('errorMessage-password','');
        }

        function pickOperation() {
            const username = document.getElementById('input-username').value.trim();
            const password = document.getELementById('input-password').value.trim();
            if (username !== '') {
                changeErrorMessage('errorMessage-username','');
                checkUsernameAvailability(username);
            } else {
                hidePasswordFields();
                changeErrorMessage('errorMessage-username','Please enter a username.');
            }
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
                            showPasswordField();
                            return true;
                        } else {
                            hidePasswordField();
                            changeErrorMessage('errorMessage-username','Username not found');
                            return false;
                        }
                    } else {
                        changeErrorMessage('errorMessage-username','Error communicating with server');

                    }
                }
            };
            xhr.send('operation=usernameExists&username=' + encodeURIComponent(username));
            return true;
        }

        function submitUser(username, password) {
             if (username !== '') {
                changeErrorMessage('errorMessage-username','');
                if (checkUsernameAvailability(username)) {
                        const xhr = new XMLHttpRequest();
                        xhr.open('POST', 'ajax-endpoint.asp', true);
                        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
                        xhr.onreadystatechange = function() {
                            if (xhr.readyState === 4) {
                                if (xhr.status === 200) {
                                    const response = JSON.parse(xhr.responseText);
                                    if (response.success) {
                                        alert("AUTHENTICATED! YIPPIE");
                                    } else {
                                        changeErrorMessage('errorMessage-password','Username & password did not match.');
                                        return false;
                                    }
                                } else {
                                    changeErrorMessage('errorMessage-password','Error communicating with server');
                                    return false;
                                }
                            }
                        }   
                        xhr.send('operation=authenticate&username=' + encodeURIComponent(username) + '&password=' + encodeURIComponent(password));
                        return true;
                }
            } else {
                hidePasswordFields();
                changeErrorMessage('errorMessage-username','Please enter a username.');
            } 
        }


        function changeErrorMessage(elementID, text) {
            document.getElementById(elementID).innerText = text;
        }

                // Function to get URL parameters
        function getUrlParameter(name) {
            name = name.replace(/[\[\]]/g, '\\$&');
            var regex = new RegExp('[?&]' + name + '(=([^&#]*)|&|#|$)'),
                results = regex.exec(window.location.href);
            if (!results) return null;
            if (!results[2]) return '';
            return decodeURIComponent(results[2].replace(/\+/g, ' '));
        }

        // Check if the 'registered' parameter is true
        var registered = getUrlParameter('registered');
        if (registered === 'true') {
            console.log('User registered successfully!');
            document.getElementById('registered').style.display = 'block';
        }

</script>
</body>
</html>
