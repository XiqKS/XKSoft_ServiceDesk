using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using XKSoft_ServiceDesk_DemoAPI.Data;
using XKSoft_ServiceDesk_DemoAPI.Models;
using XKSoft_ServiceDesk_DemoAPI.Services.DataGenerator;

namespace XKSoft_ServiceDesk_DemoAPI.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class TicketsController : ControllerBase
    {
        private readonly ServiceDeskDbContext _context;
        private readonly IConfiguration _configuration;

        public TicketsController(ServiceDeskDbContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }



        // GET: api/Tickets
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Ticket>>> GetTickets()
        {
            return await _context.Tickets.ToListAsync();
        }

        // GET: api/Tickets/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Ticket>> GetTicket(int id)
        {
            var ticket = await _context.Tickets.FindAsync(id);

            if (ticket == null)
            {
                return NotFound();
            }

            return ticket;
        }

        // PUT: api/Tickets/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{id}")]
        public async Task<IActionResult> PutTicket(int id, Ticket ticket)
        {
            if (id != ticket.TicketId)
            {
                return BadRequest();
            }

            _context.Entry(ticket).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!TicketExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Tickets
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<Ticket>> PostTicket(Ticket ticket)
        {
            _context.Tickets.Add(ticket);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetTicket", new { id = ticket.TicketId }, ticket);
        }

        // POST: api/Tickets/Generate
        // Generates and adds a specified number of random tickets
        [HttpPost("Generate/{numberOfTickets}")]
        public async Task<ActionResult<IEnumerable<Ticket>>> GenerateRandomTickets(int numberOfTickets)
        {
            var ticketGenerator = new TicketGenerator(); // Assuming TicketGenerator is accessible here
            var tickets = ticketGenerator.GenerateRandomTickets(numberOfTickets);

            foreach (var ticket in tickets)
            {
                _context.Tickets.Add(ticket);
            }

            await _context.SaveChangesAsync();

            // Return the generated tickets
            return Ok(tickets);
        }

        [HttpPost("Get/IDRange")]
        public async Task<ActionResult<dynamic>> GetRangeOfTicketIDs()
        {
            try
            {
                // Assuming _context is your database context and Tickets is your DbSet<Ticket>
                var minTicketId = await _context.Tickets.MinAsync(t => t.TicketId);
                var maxTicketId = await _context.Tickets.MaxAsync(t => t.TicketId);

                if (minTicketId == 0 && maxTicketId == 0)
                {
                    return NotFound("No tickets found in the database.");
                }

                return Ok(new { MinTicketId = minTicketId, MaxTicketId = maxTicketId });
            }
            catch (Exception ex)
            {
                // Log the exception (consider using a logging framework)
                return StatusCode(500, "Internal server error: " + ex.Message);
            }
        }


        // DELETE: api/Tickets/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTicket(int id)
        {
            var ticket = await _context.Tickets.FindAsync(id);
            if (ticket == null)
            {
                return NotFound();
            }

            _context.Tickets.Remove(ticket);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        [HttpGet]
        [Route("config/settings")]
        public IActionResult GetConfiguration()
        {

            // Retrieve the base URL dynamically from the current request
            var baseUrl = $"{Request.Scheme}://{Request.Host}";

            var settings = new
            {

                DatabaseConnectionString = _configuration.GetConnectionString("ClassicDefaultConnection"),
                ApiBaseUrl = baseUrl + "/api/",
                // other necessary config variables
            };
            return Ok(settings);
        }

        // Utility method to check if a Ticket exists
        private bool TicketExists(int id)
        {
            return _context.Tickets.Any(e => e.TicketId == id);
        }
    }
}
