// navbar.js
document.addEventListener('DOMContentLoaded', function() {
    var hamburger = document.getElementById('hamburgerButton');
    var menuItems = document.getElementById('menuItems');

    hamburger.addEventListener('click', function() {
        // Toggle the .hidden class on menuItems
        menuItems.classList.toggle('hidden');
    });
});
