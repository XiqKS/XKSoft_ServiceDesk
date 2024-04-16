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

# Download and install the Visual C++ 2017 Redistributable
RUN powershell -Command \
    Invoke-WebRequest -Uri "https://aka.ms/vs/15/release/vc_redist.x64.exe" -OutFile vc_redist.x64.exe; \
    Start-Process -FilePath vc_redist.x64.exe -ArgumentList '/install', '/passive', '/norestart' -Wait; \
    Remove-Item -Force vc_redist.x64.exe

# Download and install the SQL Server ODBC Driver 17 for SQL Server
RUN powershell -Command \
    Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=2266337" -OutFile msodbcsql.msi; \
    Start-Process msiexec.exe -ArgumentList '/i', 'msodbcsql.msi', 'IACCEPTMSODBCSQLLICENSETERMS=YES', '/qn', '/norestart', '/l*v', 'install.log' -NoNewWindow -Wait; \
    Remove-Item -Force msodbcsql.msi

# Download and prepare win-acme
RUN powershell -Command \
    New-Item -ItemType Directory -Path C:\win-acme -Force; \
    Invoke-WebRequest -Uri https://github.com/win-acme/win-acme/releases/download/v2.2.8.1635/win-acme.v2.2.8.1635.x64.pluggable.zip -OutFile C:\win-acme.zip; \
    Expand-Archive -Path C:\win-acme.zip -DestinationPath C:\win-acme; \
    Remove-Item -Path C:\win-acme.zip;

# Set IIS to display detailed error messages
RUN powershell -Command "Import-Module WebAdministration; \
    Set-WebConfigurationProperty '/system.webServer/httpErrors' -name errorMode -value 'Detailed'; \
    Set-WebConfigurationProperty '/system.webServer/asp' -name scriptErrorSentToBrowser -value True"

# Copy the Classic ASP files from your project into the container
COPY ClassicASP/ C:/inetpub/wwwroot/

# Expose HTTP and HTTPS ports
EXPOSE 80 443

# Setup the container to run win-acme if needed and start IIS
ENTRYPOINT ["powershell", "-Command", "$exists = Test-Path 'C:\\inetpub\\wwwroot\\ssl\\cert.pfx'; if (-not $exists) { .\\win-acme\\wacs.exe --target manual --host xksoftservicedesk-app.westus2.azurecontainer.io --emailaddress cbpunchy@gmail.com --accepttos --usedefaulttaskuser --certificatestore My --installation iis,script --script 'win-acme/Scripts/ImportRDSFull.ps1' --scriptparameters '{CertThumbprint}' --installationsiteid 1}; C:\\ServiceMonitor.exe w3svc"]
