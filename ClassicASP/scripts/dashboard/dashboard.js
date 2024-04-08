document.getElementById("generateTicketsBtn").addEventListener("click", function() {
    fetch('https://localhost/api/Tickets/Generate/1', {
        method: 'POST', // or 'GET' depending on your API
        headers: {
            'Content-Type': 'application/json',
            // Include other headers as needed, like authorization tokens
        },
        // If your endpoint requires a payload, include it here
        // body: JSON.stringify({ example: 'data' })
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json(); // or .text() if the response is not JSON
    })
    .then(data => {
        console.log(data); // Handle success, update the UI as needed
    })
    .catch(error => {
        console.error('There was a problem with the fetch operation:', error);
    });
});