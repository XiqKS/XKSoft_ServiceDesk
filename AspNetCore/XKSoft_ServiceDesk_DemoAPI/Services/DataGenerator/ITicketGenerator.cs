using XKSoft_ServiceDesk_DemoAPI.Models;

namespace XKSoft_ServiceDesk_DemoAPI.Services.DataGenerator
{
    public interface ITicketGenerator
    {
        List<Ticket> GenerateRandomTickets(int numberOfTickets);
    }

}
