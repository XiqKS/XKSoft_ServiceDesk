using XKSoft_ServiceDesk_DemoAPI.Models;

namespace XKSoft_ServiceDesk_DemoAPI.Services.DataGenerator
{
    public class TicketGenerator : ITicketGenerator
    {
        private static readonly Random random = new Random();
        private static readonly List<string> statuses = new List<string> { "Open", "Closed", "In Progress" };

        public List<Ticket> GenerateRandomTickets(int numberOfTickets)
        {
            List<Ticket> tickets = new List<Ticket>();
            for (int i = 0; i < numberOfTickets; i++)
            {
                tickets.Add(new Ticket
                {
                    Title = $"Ticket",
                    Description = $"This is an automatically generated ticket!",
                    Status = statuses[random.Next(statuses.Count)],
                    Priority = random.Next(1, 5), // Assuming priorities range from 1 to 4
                    CreationDate = DateTime.Now.AddDays(-random.Next(0, 30)),
                    ClosureDate = null
                }); 
            }

            // Randomly assign a closure date to closed tickets
            foreach (var ticket in tickets.Where(t => t.Status == "Closed"))
            {
                ticket.ClosureDate = ticket.CreationDate.AddDays(random.Next(1, 30));
            }

            return tickets;
        }
    }

}
