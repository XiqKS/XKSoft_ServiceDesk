<%@ Language=VBScript %>
<!--#include virtual="/utils/security-headers.asp" -->
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

    <script src="/scripts/auth/inputPolicy.js"></script>
    <link rel="stylesheet" href="../styles/login-styles.css">
    <meta name="csrf-token" content="<%=csrfToken%>">
</head>
<body>

    <div class="main-container container">
        <!--#include virtual="components/dark-mode/dark-mode.asp" -->
        <img src="../icons/helldivers2.svg" class="top-left-icon" alt="Helldivers2 Icon">
        <div class="main-content">
            <h1>XKSoft ServiceDesk</h1>
            <h2>Register</h2>
            <input type="text" class="inputEvents" id="username-field" name="username" placeholder="Username" required tabindex="1">
            <input type="password" class="inputEvents hideField" id="password-field" name="password" placeholder="Password" required tabindex="2">
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
            <input type="password" class="inputEvents hideField" id="passwordConfirm-field" name="passwordConfirm" placeholder="Confirm Password" required tabindex="3">
            <div class="error-message" id="errorMessageRegister"></div>
        </div>
        <button type="button" class="next-button" tabindex="5">Next</button>
        <div class="login-link">
            <p>Already registered? <a href="login.asp" tabindex="4">Login</a> now!</p>
        </div>
        <div class="loading-bar-wrapper">
            <div id="loadingBar" class="hideField"></div>
        </div>
    </div>
    <script src="../scripts/auth/register.js"></script>
</body>
</html>
