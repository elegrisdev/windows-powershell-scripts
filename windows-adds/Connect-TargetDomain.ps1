<#
.SYNOPSIS
  Connect to a target domain to launch remote commands

.DESCRIPTION
  Open a remote PowerShell session with specifics domain credentials

.NOTES
  Version:          1.0
  Purpose/Change:   Initial script development
  Requirements:     PowerShell 5
  Purpose:          Manually
#>

function Connect-TargetDomain {
    Param(
        # FQDN
        [Parameter(Mandatory=$True)]
        [string]$TargetDomain
    )

    # Connect to target domain
    Try {
        $session = New-PSSession -ComputerName $TargetDomain -Credential (Get-Credential)
        Invoke-Command $session -Scriptblock { Import-Module ActiveDirectory }
        Import-PSSession -Session $session -module ActiveDirectory -AllowClobber

        # Return the DC list for the target domain
        Get-ADDomainController -Filter * | Select-Object name
    }
    Catch {}
}

Connect-TargetDomain