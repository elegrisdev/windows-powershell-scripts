<#
.SYNOPSIS
  Reset AD password for On-Premise ADDS

.DESCRIPTION
  Open remote session with Active Directory PowerShell module and proceed to a password reset

.NOTES
  Version:          1.0
  Purpose/Change:   Initial script development
  Requirements:     PowerShell 5
  Purpose:          Manually
#>

function Reset-ADAccountPassword {
    Param(
        # FQDN
        [Parameter(Mandatory = $True)]
        [string]$targetDomain,

        # ADDS Username
        [Parameter(Mandatory = $True)]
        [string]$userName,

        # ADDS Old Password
        [Parameter(Mandatory = $True)]
        [securestring]$oldPassword,

        # ADDS New Password
        [Parameter(Mandatory = $True)]
        [securestring]$newPassword
    )

    try {
        # Set the new password remotely
        Set-ADAccountPassword -Server $targetDomain -Identity $userName -OldPassword $oldPassword -NewPassword $newPassword
    }

    Catch {}
}

Reset-ADAccountPassword