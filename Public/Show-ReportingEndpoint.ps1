<#
.SYNOPSIS
Displays the reporting endpoint for a given customer by calculating the Mailhardener ID in hex.
Accepts a customer ID as input or a piped customer object.

.PARAMETER Id
The Mailhardener customer ID / UID.

.INPUTS
PSCustomObject
Mailhardener customer object returned from API

.OUTPUTS
String

.LINK
https://api.mailhardener.com/docs/#/paths/customer/post

.EXAMPLE
PS> Show-ReportingEndpoint -Id 1234567890
499602d2@in.mailhardener.com

.EXAMPLE
$customer = Get-Customer -Id 1234567890
$customer | Show-ReportingEndpoint
499602d2@in.mailhardener.com

#>
function Show-ReportingEndpoint {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('uid')]
        [int]$Id
    )
    process {
        "$('{0:x}' -f $Id)@in.mailhardener.com"
    }
}