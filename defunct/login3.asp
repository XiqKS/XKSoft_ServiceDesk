<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Claims Management System</title>

    <link rel="stylesheet" href="../styles/login-styles.css">
    <!--#include virtual="/dark-mode/dark-mode.asp" -->
</head>
<body>
    <div class="container">
        <h1>Welcome to the Claims Management System</h1>
        <p>This system allows you to submit and manage your claims efficiently.</p>
        <form action="authentication-process.asp" method="post">
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" required>
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            <div class="form-group">
                <button type="submit" class="login-btn">Login</button>
            </div>
        </form>
        <div class="register-container">
            <p>Not registered? <a href="register.asp">Sign up</a> now!</p>
        </div>
    </div>
</body>
</html>
