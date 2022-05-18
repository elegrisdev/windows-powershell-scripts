<#
.SYNOPSIS
  Get DNS staled records

.DESCRIPTION
  Connect to DNS with DNSServer module and list all staled records since 1 day.
  The script will aslk to the user the zone name and if he want to print informations or export to CSV

.NOTES
  Version:          1.0
  Purpose/Change:   Initial script development
  Requirements:     PowerShell 5, DNSServer PowerShell module
  Purpose:          Manually
#>

# Global Parameters
$DaysBack = 1
$PastDate = (Get-Date).AddDays(-$DaysBack)

# User Input
$ServerZones = Read-Host 'Specify a DNS zone name or type enter to list results for all zones'
$PrintOrExport = Read-Host 'Do you want to print the output or export to a csv ? (print/csv)'

# Function to list records from 
function Get-Records {
    $ToArray = Get-DnsServerResourceRecord -ZoneName $ServerZone | Where-Object { ($_.Timestamp -lt $PastDate) -and ($null -ne $_.Timestamp) }[0]
    
    if ($PrintOrExport -eq "print") {
        $ToArray     
    }
    elseif ($PrintOrExport -eq "csv") {
        $ToArray | Export-Csv -Path $env:TEMP\$(Get-Date -Format dd_MM_yyyy)_$ServerZone'_StaledRecords'.csv -NoTypeInformation
    }
    
}

# Function to print the CSV path if user choose to export to CSV
function Get-Output {
    if ($PrintOrExport -eq "csv") {
        Write-Host "All CSV have been exported under path '$env:TEMP'"
    }
}

# Determine the function to use if user choose all zones or specific zone
function Get-ZoneChoice {
    if ([string]::IsNullOrEmpty($ServerZones)) {
        $ServerZones = Get-DnsServerZone | ForEach-Object { $_.ZoneName }
        foreach ($ServerZone in $ServerZones) {
            Get-Records
        }
    }
    else {
        $ServerZone = $ServerZones
        Get-Records
    }
    
}

Get-ZoneChoice
Get-Output