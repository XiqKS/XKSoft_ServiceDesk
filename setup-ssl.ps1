# Create a self-signed certificate
$cert = New-SelfSignedCertificate -DnsName "localhost" -CertStoreLocation cert:\LocalMachine\My

# Bind the certificate to port 443
New-WebBinding -Name "Default Web Site" -IP "*" -Port 443 -Protocol https
$binding = Get-WebBinding -Name "Default Web Site" -Protocol https
$binding.AddSslCertificate($cert.GetCertHashString(), "MY")
