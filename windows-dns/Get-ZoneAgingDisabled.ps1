<#
.SYNOPSIS
  List DNS zone where aging is disabled

.DESCRIPTION
  Connect to DNS with DNSServer module and list all zones where aging is disabled

.NOTES
  Version:          1.0
  Purpose/Change:   Initial script development
  Requirements:     PowerShell 5, DNSServer PowerShell module
  Purpose:          Manually
#>

# Get the server zones list from the DNS
$ServerZones = Get-DnsServerZone | ForEach-Object { $_.ZoneName }

# List all aging disabled zones
foreach ($ServerZone in $ServerZones)
{
    $ZoneAging = Get-DnsServerZoneAging -Name $ServerZone
    if (!$ZoneAging.AgingEnabled) {
        # Write-Host "Zone Name: $ServerZone"
        [PSCustomObject]@{
            ZoneName = $ServerZone
        }
    }
}