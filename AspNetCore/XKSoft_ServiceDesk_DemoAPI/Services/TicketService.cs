using XKSoft_ServiceDesk_DemoAPI.Data;
using XKSoft_ServiceDesk_DemoAPI.Models;
using XKSoft_ServiceDesk_DemoAPI.Services.DataGenerator;

namespace XKSoft_ServiceDesk_DemoAPI.Services
{
    public class TicketService
    {
        private readonly ServiceDeskDbContext _context;
        private readonly ITicketGenerator _ticketGenerator;

        public TicketService(ServiceDeskDbContext context, ITicketGenerator ticketGenerator)
        {
            _context = context;
            _ticketGenerator = ticketGenerator;
        }

        public async Task<Ticket> AddTicketAsync(Ticket ticket)
        {
            _context.Tickets.Add(ticket);
            await _context.SaveChangesAsync();
            return ticket;
        }

    }
}