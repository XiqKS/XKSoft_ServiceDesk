using Microsoft.Azure.Management.Fluent;
using Microsoft.Azure.Management.ResourceManager.Fluent;
using Microsoft.Azure.Management.ContainerInstance.Fluent;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;
using System.Threading.Tasks;
using Azure.Identity;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddFunctionsWorker();

var app = builder.Build();
app.MapFunctionsWorker();

app.Run();

[Function("UpdateACI")]
public static async Task<HttpResponseData> Run(
    [HttpTrigger(AuthorizationLevel.Function, "post")] HttpRequestData req,
    FunctionContext executionContext)
{
    var logger = executionContext.GetLogger("UpdateACI");
    logger.LogInformation("C# HTTP trigger function processed a request.");

    // Use DefaultAzureCredential which will use Managed Identity when deployed to Azure
    var credentials = new DefaultAzureCredential();

    var azure = Azure
        .Configure()
        .Authenticate(credentials)
        .WithDefaultSubscription();

    string resourceGroupName = "XKSoft_ServiceDesk_Resources";
    string containerGroupName = "xksoftservicedeskcontainer";
    string containerImage = "xiqks/xksoftservicedesk:latest";

    try
    {
        var containerGroup = await azure.ContainerGroups.GetByResourceGroupAsync(resourceGroupName, containerGroupName);
        if (containerGroup != null)
        {
            // Assuming the container group has only one container
            var container = containerGroup.Containers[containerGroupName];
            containerGroup.Update()
                .WithoutContainer(container.Name)
                .WithWindowsContainerInstance(container.Name, containerImage, container.Resources)
                .Apply();
            logger.LogInformation("Container updated successfully.");
        }
        else
        {
            logger.LogError("Container Group not found.");
        }
    }
    catch (System.Exception ex)
    {
        logger.LogError($"Error updating container: {ex.Message}");
        var response = req.CreateResponse(System.Net.HttpStatusCode.InternalServerError);
        await response.WriteStringAsync("Failed to update the container.");
        return response;
    }

    var okResponse = req.CreateResponse(System.Net.HttpStatusCode.OK);
    await okResponse.WriteStringAsync("Container updated successfully.");
    return okResponse;
}
