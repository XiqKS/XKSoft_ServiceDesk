document.addEventListener("DOMContentLoaded", function() {
// Event handler for keypress on input fields
    document.querySelectorAll('.inputEvents').forEach(function(input) {
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
    const nextButton = document.querySelector('.next-button');
    if (nextButton) {
        nextButton.addEventListener('click', chooseProcess);
    }
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
            changeErrorMessage('Username not found.');
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