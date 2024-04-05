    document.addEventListener("DOMContentLoaded", function() {
        var darkmodeCheckBox = document.getElementById("darkmode-toggle");
        if(darkmodeCheckBox) {
            darkmodeCheckBox.addEventListener("click", toggleDarkMode);
        }
    });
    
    
    // Toggle dark mode function
    function toggleDarkMode() {
        const body = document.body;
        body.classList.toggle('dark-mode');
        setCookie('darkModeEnabled', body.classList.contains('dark-mode') ? 'true' : 'false', 365);
    }

    // Initialize dark mode function
    function initializeDarkMode() {
        const darkModeEnabled = getCookie('darkModeEnabled');
        const darkModeSwitch = document.getElementById('darkmode-toggle');
        if (darkModeEnabled === 'true') {
            document.body.classList.add('dark-mode');
            darkModeSwitch.checked = true;
        }
    }

    // Add event listener for keypress events
    const darkModeToggle = document.getElementById('darkModeToggle');
    darkModeToggle.addEventListener('keypress', function(event) {
        // Check if the pressed key is Enter or Space
        if (event.key === 'Enter' || event.key === ' ') {
            // Trigger a click event on the dark mode toggle checkbox
            const darkModeSwitch = document.getElementById('darkmode-toggle');
            darkModeSwitch.click();
        }
    });


    window.onload = initializeDarkMode();