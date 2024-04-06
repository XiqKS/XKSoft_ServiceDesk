namespace XKSoft_ServiceDesk_DemoAPI.Models
{
    public class Ticket
    {
        public int TicketId { get; set; } // Primary key
        public string Title { get; set; }
        public string Description { get; set; }
        public string Status { get; set; }
        public int? Priority { get; set; }
        public DateTime CreationDate { get; set; }
        public DateTime? ClosureDate { get; set; } // Nullable for tickets that aren't closed yet
        public string? Assignee { get; set; } // Can be null if not yet assigned
    }
}
