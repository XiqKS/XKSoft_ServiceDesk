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
<link rel="stylesheet" href="/components/dark-mode/dark-styles.css">
<script src="/scripts/client-cookie-functions.js"></script>
<div class="darkmode-toggle-container" tabindex="999" id="darkModeToggle">
    <input type="checkbox" id="darkmode-toggle" class="darkmode-toggle-checkbox">
    <label for="darkmode-toggle" class="darkmode-toggle-label">
        <div class="darkmode-toggle-slider"></div>
    </label>
</div>
<script src="/components/dark-mode/dark-mode.js"></script>
