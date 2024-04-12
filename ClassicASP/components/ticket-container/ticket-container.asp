<link rel="stylesheet" href="/components/ticket-container/ticket-container.css">
<link rel="stylesheet" href="/components/dual-range-slider/dual-range-slider.css">
<script src="/components/dual-range-slider/dual-range-slider.js"></script>
<div class="sticky-bar">
    <!--#include virtual="/components/navbar/navbar.asp" -->
    <div class="filter-container container">
        <input type="text" id="searchBox" class="filter" placeholder="Search...">

        <div id="ticketIDSlider" class="filter slider">
            <!--#include virtual="/components/dual-range-slider/dual-range-slider-structure.asp" -->
        </div>

        <div class="filter dropdown">
            <label for="status">Status:</label>
            <select id="status" default="All">
                <option value="All">All</option>
                <option value="Open" selected>Open</option>
                <option value="Closed">Closed</option>
                <option value="In Progress">In Progress</option>
            </select>
        </div>
        
        <div id="prioritySlider" class="filter slider">
            <!--#include virtual="/components/dual-range-slider/dual-range-slider-structure.asp" -->
        </div>

        <div class="filter date-range">
            <label for="creationDateFrom">Creation Date From:</label>
            <input type="date" id="creationDateFrom">
            <label for="creationDateTo">To:</label>
            <input type="date" id="creationDateTo">
        </div>
    </div>
</div>


<div id="ticketsTable">
    <table>
        <thead>
            <tr>
                <th>Ticket ID <span class="sort-indicator"></span></th>
                <th>Title <span class="sort-indicator"></span></th>
                <th>Description <span class="sort-indicator"></span></th>
                <th>Status <span class="sort-indicator"></span></th>
                <th>Priority <span class="sort-indicator"></span></th>
                <th>Assignee <span class="sort-indicator"></span></th>
                <th>Creation Date <span class="sort-indicator"></span></th>
                <th>Closure Date <span class="sort-indicator"></span></th>
            </tr>
        </thead>
        <tbody id="ticketsBody">
            <!-- Tickets will be inserted here by JavaScript -->
        </tbody>
    </table>
</div>
<script src="/utils/jsAJAX.asp"></script>
<script src="/components/ticket-container/ticket-container.js"></script>
