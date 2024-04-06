using Microsoft.EntityFrameworkCore;
using XKSoft_ServiceDesk_DemoAPI.Models; // Ensure you're using the correct namespace
namespace XKSoft_ServiceDesk_DemoAPI.Data
{
    public class ServiceDeskDbContext : DbContext
    {
        public ServiceDeskDbContext(DbContextOptions<ServiceDeskDbContext> options)
            : base(options)
        {
        }

        public DbSet<Ticket> Tickets { get; set; }
    }
}
