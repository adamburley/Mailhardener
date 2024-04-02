<#
.SYNOPSIS
Retrieves team member information from the Mailhardener API.

.DESCRIPTION
Get a list of team members for a specific customer or retrieve a specific team member by ID.

.PARAMETER CustomerId
Mailhardener ID / EID for the desired customer.

.PARAMETER Id
Team member Mailhardener ID / EID. If specified, only the team member with the matching ID will be retrieved.

.OUTPUTS
PSCustomObject
PSCustomObject[]

.EXAMPLE
Get-TeamMember -CustomerId "1234567890" -Id "0987654321"

.EXAMPLE
Get-TeamMember -CustomerId "1234567890"
Retrieves all team members for the specified custoemr
#>
function Get-TeamMember {
    [CmdletBinding()]
    [OutputType([PSCustomObject],[PSCustomObject[]])]
    param (
        [Parameter(Mandatory)]
        [Alias('customer_uid')]
        [string]$CustomerId,

        [Parameter()]
        [Alias('uid','team_member_uid')]
        [string]$Id
    )
    if ($Id) {
        Invoke-MailhardenerGETRequest -Endpoint "customer/$CustomerId/team_member/$Id"
    }
    else {
        Invoke-MailhardenerGETRequest -Endpoint "customer/$CustomerId/team_member" -All
    }    
}