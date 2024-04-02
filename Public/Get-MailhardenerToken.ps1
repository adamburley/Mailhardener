<#
.SYNOPSIS
Returns current Mailhardener access token.

.DESCRIPTION
Returns the current Oauth2 access token for use with direct API calls.

.INPUTS
None

.OUTPUTS
System.String

.EXAMPLE
Get-MailhardenerToken

#>
function Get-MailhardenerToken {
    if ($null -eq $Script:MailhardenerAccessToken) {
        Write-Warning "Mailhardener access token not found. Please run Connect-Mailhardener."
    }
    else {    
        return $script:MailhardenerAccessToken
    }
}