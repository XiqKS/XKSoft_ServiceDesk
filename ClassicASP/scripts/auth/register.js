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
    
    const nextButton = document.querySelector('.next-button');
    if (nextButton) {
        nextButton.addEventListener('click', chooseProcess);
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
        togglePasswordFields(false);
        changeErrorMessage('Please enter a username.');
    } else if (!checkUsername(username)) {
        togglePasswordFields(false);
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

function togglePasswordFields(show) {
    const passwordField = document.getElementById('password-field');
    const passwordConfirmField = document.getElementById('passwordConfirm-field');
    if (show) {
        passwordField.classList.remove('hideField');
        passwordConfirmField.classList.remove('hideField');
    } else {
        passwordField.classList.add('hideField');
        passwordConfirmField.classList.add('hideField');
    }
}

function changeErrorMessage(text) {
    document.getElementById('errorMessageRegister').innerText = text;
}

// Define a function to handle showing and hiding the loading bar
function toggleLoadingBar(show) {
    const loadingBar = document.getElementById('loadingBar');
    show ? loadingBar.classList.remove('hideField') : loadingBar.classList.add('hideField');
}

async function checkUsernameAvailability(username) {
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
    toggleLoadingBar(true); // Show loading bar 

    try {
        const response = await fetch('/auth/ajax-endpoint.asp', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: `operation=usernameExists&username=${encodeURIComponent(username)}&csrfToken=${encodeURIComponent(csrfToken)}`
        });
        const data = await response.json();
        await delay(500);
        toggleLoadingBar(false); // Hide loading bar after request

        if (!data.success) {
            togglePasswordFields(true);
        } else {
            togglePasswordFields(false);
            changeErrorMessage('Username not available.');
        }
    } catch (error) {
        console.error('Error:', error);
        toggleLoadingBar(false); // Hide loading bar on error
        changeErrorMessage('Error communicating with server.');
    }
}

async function registerUser(username, password) {
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
    toggleLoadingBar(true); // Show loading bar

    try {
        const response = await fetch('/auth/ajax-endpoint.asp', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: `operation=register&username=${encodeURIComponent(username)}&password=${encodeURIComponent(password)}&csrfToken=${encodeURIComponent(csrfToken)}`
        });
        const data = await response.json();
        await delay(500);
        toggleLoadingBar(false); // Hide loading bar after request

        if (data.success) {
            window.location.href = "login.asp?registered=true";
        } else {
            changeErrorMessage('Error registering user.');
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
