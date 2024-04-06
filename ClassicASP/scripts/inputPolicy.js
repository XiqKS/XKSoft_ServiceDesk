// inputPolicy.js

// Final validation functions
function checkUsername(username) {
    return /^[a-zA-Z0-9_-]{3,20}$/.test(username);
}

function checkPassword(password) {
    return /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/.test(password);
}

// Individual password requirement functions
function checkPasswordLength(password) {
    return password.length >= 8;
}

function checkPasswordUpperCase(password) {
    return /[A-Z]/.test(password);
}

function checkPasswordLowerCase(password) {
    return /[a-z]/.test(password);
}

function checkPasswordDigit(password) {
    return /\d/.test(password);
}

function checkPasswordSymbol(password) {
    return /[@$!%*?&]/.test(password);
}

// Keypress event handler functions
function isValidUsernameCharacter(char) {
    return /^[a-zA-Z0-9_-]$/.test(char);
}

function isValidPasswordCharacter(char) {
    return /^[ -~]$/.test(char); // ASCII characters from space to tilde (all printable characters)
}

