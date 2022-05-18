<#
.SYNOPSIS
  Bind a new certificate thumbprint to IIS sites (Only work if certificate is already in local store)

.DESCRIPTION
  Check all sites using provided host header and bind the new thumprint on those sites.

.NOTES
  Version:          1.0
  Purpose/Change:   Initial script development
  Requirements:     WebAdministration PowerShell module
  Purpose:          Automation (Can still be executed manually)
#>

[CmdletBinding()]
param (
    # Host name of the site
    [Parameter(Mandatory=$true)]
    [string] $hostHeader,

    # Thumbprint of the new certificate
    [Parameter(Mandatory=$true)]
    [string] $newHash
)

Write-Host "Importing PowerShell modules"
            
Import-Module WebAdministration -Force

$binding = Get-WebBinding -Protocol https | Where-Object {$_ -like "*$hostHeader*"}

foreach ($item in $binding) {

    $site = $item.bindingInformation
    
    Write-Host "Binding certificate for $site" -ForegroundColor Yellow

    $newCert = Get-ChildItem Cert:\LocalMachine\MY\$newHash

    $binding.AddSslCertificate($newCert.GetCertHashString(), "my")

    Write-Host "Binding completed successfully"

}

Write-Host 
Write-Host "Final report"
Write-Host

Get-ChildItem cert:\LocalMachine\my | Select-Object * | ForEach-Object {

    $found = $false
    $tp = $_.Thumbprint
    Get-ChildItem IIS:\SslBindings | ForEach-Object {
        if ($_.Thumbprint -eq $tp)
        {
        Write-Host "$($_.Host) $($_.IpAddress)"
        $found = $true
        }    
    }
    if ($found)
    {
        Write-Host
        Write-Host $tp -foregroundcolor green
        Write-Host $_.Subject -foregroundcolor green
        Write-Host $_.NotAfter -foregroundcolor green
        Write-Host
        Write-Host "***************************************************************"
        Write-Host
    }
}