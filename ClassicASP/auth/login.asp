<%@ Language=VBScript %>
<!--#include virtual="/utils/security-headers.asp" -->
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
    
    <script src="/scripts/inputPolicy.js"></script>
    <link rel="stylesheet" href="/styles/login-styles.css">
    <meta name="csrf-token" content="<%=csrfToken%>">
</head>
<body>
    <div class="main-container container">
        <!--#include virtual="components/dark-mode/dark-mode.asp" -->
        <img src="/icons/helldivers2.svg" class="top-left-icon" alt="Helldivers2 Icon">
        <div class="main-content">
            <h1>XKSoft ServiceDesk</h1>
            <h2>Login</h2>
            <input type="text" class="inputEvents" id="username-field" name="username" placeholder="Username" required tabindex="1">
            <input type="password" class="inputEvents hideField" id="password-field" name="password" placeholder="Password" required tabindex="2">
            <div class="error-message" id="errorMessageLogin"></div>
        </div>
        <button type="button" class="next-button" tabindex="5">Next</button>
        <div class="login-link">    
            <p>Don't have an account? <a href="register.asp" tabindex="4">Register</a> now!</p>
        </div>
        <div class="loading-bar-wrapper">
            <div id="loadingBar" class="hideField"></div>
        </div>
    </div>
    <script src="/scripts/auth/login.js"></script>
</body>
</html>
