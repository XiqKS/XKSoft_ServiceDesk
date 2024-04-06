using System.IO;
using System.Text.Json;
using System.Collections.Generic;
using XKSoft_ServiceDesk_DemoAPI.Models;

namespace XKSoft_ServiceDesk_DemoAPI.Services.DataGenerator
{
    public class TicketLoader
    {
        public static List<Ticket> LoadTicketsFromJson(string filePath)
        {
            var jsonString = File.ReadAllText(filePath);
            return JsonSerializer.Deserialize<List<Ticket>>(jsonString) ?? new List<Ticket>();
        }
    }
}
