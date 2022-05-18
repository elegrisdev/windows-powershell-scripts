<#
.SYNOPSIS
  List DNS zone where aging is enabled

.DESCRIPTION
  Connect to DNS with DNSServer module and list all zones where aging is enabled

.NOTES
  Version:          1.0
  Purpose/Change:   Initial script development
  Requirements:     PowerShell 5, DNSServer PowerShell module
  Purpose:          Manually
#>

# Get the server zones list from the DNS
$ServerZones = Get-DnsServerZone | ForEach-Object { $_.ZoneName }

# List all aging enabled zones with refresh and non-refresh intervals
foreach ($ServerZone in $ServerZones)
{
    $ZoneAging = Get-DnsServerZoneAging -Name $ServerZone
    $RefreshInterval = $ZoneAging.RefreshInterval
    $NoRefreshInterval = $ZoneAging.NoRefreshInterval
    if ($ZoneAging.AgingEnabled) {
        #Write-Host "Zone Name: $ServerZone "
        [PSCustomObject]@{
            ZoneName = $ServerZone
            NoRefreshInterval = $NoRefreshInterval
            RefreshInterval = $RefreshInterval
        }
    }
}