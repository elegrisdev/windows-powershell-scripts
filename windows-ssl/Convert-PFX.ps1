<#
.SYNOPSIS
  Convert a public certificate, private key and root certificate in PFX format using OpenSSL

.DESCRIPTION
  Get a public certificate, private key and root certificate from the current directory and create a PFX certificate.

  Before using this script :
    Get the private key from the security team and rename with a ".key" in the same folder of this script
    Download IIS certificates from the provider and extract the files in the same directory of this script
    Run the script and choose a password for the extracted PFX

.NOTES
  Version:          1.0
  Purpose/Change:   Initial script development
  Requirements:     PowerShell, OpenSSL
  Purpose:          Manually
#>

# Get name for the new certificate to generate
$certName = Read-Host -Prompt "Please enter a name for the new pfx certificate: "

# Grab file informations in the current directory
$certFileName = Get-ChildItem -Path .\ -Filter *.pem -Recurse -File -Name
$certFileKey = Get-ChildItem -Path .\ -Filter *.key -Recurse -File -Name
$certFileRoot = Get-ChildItem -Path .\ -Filter *.p7b -Recurse -File -Name

# Create Root + Intermediate certificate compatible format
openssl pkcs7 -print_certs -in $certFileRoot -out RootIntermediates.cer

# Append Root and Intermediates to the certificate
cp ".\$certFileName" ".\$certName.crt"
$newCertFileRoot = Get-ChildItem -Path .\ -Filter *.cer -Recurse -File -Name
$From = Get-Content -Path ".\$newCertFileRoot"
Add-Content -Path ".\$certFileName" -Value $From

# Generate PFX from Certificate and Key
openssl pkcs12 -export -out "$certName.pfx" -inkey ".\$certFileKey" -in ".\$certFileName"

# Cleanup
rm ".\$certName.crt"
rm ".\$newCertFileRoot"