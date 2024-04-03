<!-- 
    Container for the dark-mode slider
    Imports getCookie and setCookie from ../scripts/cookie-functions.js
    Initializes dark-mode on window load based on cookie state
 -->    
<%
' Check if dark mode is enabled
dim darkModeEnabled
darkModeEnabled = Request.Cookies("darkModeEnabled")

' Set default mode
if darkModeEnabled = "" then
    darkModeEnabled = "false"
end if
%>
<link rel="stylesheet" href="../dark-mode/dark-styles.css">
<script src="../scripts/cookie-functions.js"></script>
<div class="darkmode-toggle-container" tabindex="999" id="darkModeToggle">
    <input type="checkbox" id="darkmode-toggle" class="darkmode-toggle-checkbox" onclick="toggleDarkMode()">
    <label for="darkmode-toggle" class="darkmode-toggle-label">
        <div class="darkmode-toggle-slider"></div>
    </label>
</div>
<script>
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
</script>
