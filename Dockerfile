# Use the ASP.NET 4.8 base image from Microsoft
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019

# Install Windows Features and remove the default IIS content
RUN powershell -Command Add-WindowsFeature Web-Asp; \
    Add-WindowsFeature Web-Basic-Auth; \
    Add-WindowsFeature Web-Windows-Auth; \
    Add-WindowsFeature Web-CGI; \
    Add-WindowsFeature Web-ISAPI-Ext; \
    Add-WindowsFeature Web-ISAPI-Filter; \
    Add-WindowsFeature Web-Includes; \
    Remove-Item -Recurse C:\inetpub\wwwroot\*

# Register DLLs using RegAsm
COPY ClassicASP/dependencies/*.dll C:/Windows/Microsoft.NET/Framework64/v4.0.30319/
RUN powershell -Command C:\Windows\Microsoft.NET\Framework64\v4.0.30319\RegAsm.exe /tlb /codebase C:/Windows/Microsoft.NET/Framework64\v4.0.30319/ClassicASP.Argon2.dll; \
    C:\Windows\Microsoft.NET\Framework64\v4.0.30319\RegAsm.exe /tlb /codebase C:/Windows/Microsoft.NET/Framework64\v4.0.30319/Isopoh.Cryptography.Argon2.dll; \
    C:\Windows\Microsoft.NET\Framework64\v4.0.30319\RegAsm.exe /tlb /codebase C:/Windows/Microsoft.NET/Framework64\v4.0.30319/Isopoh.Cryptography.Blake2b.dll; \
    C:\Windows\Microsoft.NET\Framework64\v4.0.30319\RegAsm.exe /tlb /codebase C:/Windows/Microsoft.NET/Framework64\v4.0.30319/Isopoh.Cryptography.SecureArray.dll

# Copy the Classic ASP files from your project into the container (if these change frequently, keep this step later)
COPY ClassicASP/ C:/inetpub/wwwroot/

# Expose HTTP and HTTPS ports
EXPOSE 80 443

# Configure the container to run IIS
ENTRYPOINT ["C:\\ServiceMonitor.exe", "w3svc"]
