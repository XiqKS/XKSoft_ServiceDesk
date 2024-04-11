let masterData = []; // Original data, fetched from the server or source
let lastSortedProperty = '';
let lastSortedOrder = true; // true for ascending, false for descending
var lowID = 0;
var highID = 10000;
var lowPriority = 0;
var highPriority = 5;


document.addEventListener("DOMContentLoaded", function() {
    // Setup table sorting listeners
    document.querySelectorAll("th").forEach((header, index) => {
        header.addEventListener("click", function() {
            sortTable(index);
        });
    });
    
    // Fetch tickets data from the API
    fetch(`${API_BASE_URL}Tickets`)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json(); // Parse the response body as JSON
        })
        .then(data => {
            masterData = data; // Assign the parsed JSON (which is an array of objects) to your variable
            applyFilters(); // Initial display with filters applied if any
        })
        .catch(error => {
            console.error('There was a problem with the fetch operation:', error);
        });

    // Status filter listener
    document.getElementById('status').addEventListener('change', applyFilters);

    // Search box listener
    document.getElementById('searchBox').addEventListener('input', applyFilters);

    // Date filter listeners
    document.getElementById('creationDateFrom').addEventListener('change', applyFilters);
    document.getElementById('creationDateTo').addEventListener('change', applyFilters);

    // Initialize dual range sliders with component's init function
    initDualRangeSlider('ticketIDSlider','ID #', callbackID);
    configDualRangeSlider('ticketIDSlider',0,10000);
    
    fetch(`${API_BASE_URL}Tickets/Get/IDRange`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            // Add any other headers here
        },
        // If your API doesn't need a body for this POST request, you can omit this part
        })
        .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
        })
        .then(data => {
        const minTicketId = data.minTicketId;
        const maxTicketId = data.maxTicketId;
        lowID = minTicketId;
        highID = maxTicketId;

        configDualRangeSlider('ticketIDSlider',minTicketId,maxTicketId);

        })
        .catch(error => {
        console.error('There was a problem with your fetch operation:', error);
    });

    
    
    initDualRangeSlider('prioritySlider','Priority', callbackPriority);
    configDualRangeSlider('prioritySlider',0,5);
});

function displayTable(data) {
    const ticketsBody = document.getElementById('ticketsBody');
    
    ticketsBody.innerHTML = ''; // Clear existing rows

    data.forEach(ticket => {
        const row = ticketsBody.insertRow();
        Object.values(ticket).forEach((value, index) => {
            let displayValue;
            // Assuming the date/time columns are known, e.g., at indexes 6 and 7
            if (index === 6 || index === 7) {
                displayValue = value ? formatDate(value) : 'N/A';
            } else {
                displayValue = value === null ? 'N/A' : value.toString();
            }
            row.insertCell(index).textContent = displayValue;
        });
    });
}

function callbackID(fromValue, toValue) {
    lowID = fromValue;
    highID = toValue;
    applyFilters();
}

// slider callback function
function callbackPriority(fromValue, toValue) {
    lowPriority = fromValue;
    highPriority = toValue;
    applyFilters();
}

function formatDate(isoString) {
    if (!isoString) return 'N/A'; // Return a placeholder if the date string is falsy
    const date = new Date(isoString);
    // Specify your desired options
    const options = { year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true };
    return new Intl.DateTimeFormat('en-US', options).format(date);
}

function sortTable(cellIndex) {
    const propertyMap = ['ticketId', 'title', 'description', 'status', 'priority', 'assignee', 'creationDate', 'closureDate'];
    if (cellIndex < propertyMap.length) {
        const property = propertyMap[cellIndex];
        const isAscending = lastSortedProperty !== property || !lastSortedOrder;
        lastSortedProperty = property;
        lastSortedOrder = isAscending;

        masterData.sort((a, b) => {
            if (isAscending) return a[property] > b[property] ? 1 : -1;
            else return a[property] < b[property] ? 1 : -1;
        });

        // Clear existing indicators
        document.querySelectorAll("th .sort-indicator").forEach(indicator => {
            indicator.className = 'sort-indicator'; // Reset class
        });

        // Add the correct indicator to the clicked column
        const currentHeader = document.querySelectorAll("th")[cellIndex];
        const currentIndicator = currentHeader.querySelector(".sort-indicator");
        if (isAscending) {
            currentIndicator.classList.add('sort-asc');
        } else {
            currentIndicator.classList.add('sort-desc');
        }

        applyFilters(); // Reapply filters after sorting
    }
}

function applyFilters() {
    const statusFilter = document.getElementById('status').value.toLowerCase();
    const searchFilter = document.getElementById('searchBox').value.toLowerCase();
    const creationDateFrom = document.getElementById('creationDateFrom').value;
    const creationDateTo = document.getElementById('creationDateTo').value;

    filteredData = masterData.filter(ticket => {
        const matchesStatus = statusFilter === 'all' || ticket.status.toLowerCase() === statusFilter;
        
        const matchesSearch = Object.values(ticket).some(value => {
            if (value === null) return false;
            return value.toString().toLowerCase().includes(searchFilter);
        });

        const ticketCreationDate = new Date(ticket.creationDate);
        const fromDate = creationDateFrom ? new Date(creationDateFrom) : null;
        const toDate = creationDateTo ? new Date(creationDateTo) : null;
        const matchesDateRange = (!fromDate || ticketCreationDate >= fromDate) && (!toDate || ticketCreationDate <= toDate);

        // Add ID and Priority range filters
        const withinIDRange = ticket.ticketId >= lowID && ticket.ticketId <= highID;
        const withinPriorityRange = ticket.priority >= lowPriority && ticket.priority <= highPriority;

        return matchesStatus && matchesSearch && matchesDateRange && withinIDRange && withinPriorityRange;
    });

    displayTable(filteredData);
}


