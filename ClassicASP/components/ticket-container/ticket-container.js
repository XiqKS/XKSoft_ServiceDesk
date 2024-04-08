// Fetch tickets data from the API
fetch('https://localhost:44308/api/tickets')
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        const ticketsBody = document.getElementById('ticketsBody');
        
        // Clear existing rows
        ticketsBody.innerHTML = '';

        // Insert new rows of tickets
        data.forEach(ticket => {
            const row = ticketsBody.insertRow();
            row.insertCell(0).textContent = ticket.title;
            row.insertCell(1).textContent = ticket.description;
            row.insertCell(2).textContent = ticket.status;
            row.insertCell(3).textContent = ticket.priority;
            row.insertCell(4).textContent = new Date(ticket.creationDate).toLocaleDateString();
        });
    })
    .catch(error => {
        console.error('Error fetching tickets:', error);
    });
