<#
.SYNOPSIS
Remove a team member from a customer's environment.

.DESCRIPTION
Revokes a team member user's access to a customer environment.
The user will receive an email notifying them of this change.

.INPUTS
PSCustomObject
Team member object from Get-TeamMember.

.OUTPUTS
None

.PARAMETER CustomerId
The Mailhardener ID / UID for the customer.

.PARAMETER Id
The Mailhardener ID / UID for the team member.

.LINK
https://api.mailhardener.com/docs/#/paths/customer-customer_uid--team_member--team_member_uid/delete

.EXAMPLE
Remove-TeamMember -CustomerId "1234567890" -Id "0987654321"

.EXAMPLE
Get-TeamMember -CustomerId "1234567890" | Remove-TeamMember
# Removes all team members from customer 1234567890.

.EXAMPLE
Remove-TeamMember -CustomerId "1234567890" -Id "0987654321" -Confirm:$false
# Remove team member without confirmation.
#>
function Remove-TeamMember {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param(
        [Parameter(Mandatory)]
        [Alias('customer_uid')]
        [string]$CustomerId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('team_member_uid', 'uid')]
        [string]$Id
    )
    process {
        if ($PSCmdlet.ShouldProcess("Team member $Id under customer $CustomerId", "Revoke customer team member access to customer environment")) {
            $call = Invoke-MailhardenerDELETERequest -Endpoint "customer/$CustomerId/team_member/$Id"
            if ($call.result -eq 'success') {
                Write-Verbose "Successfully revoked customer team member $Id's access to customer $CustomerId."
            }
            else {
                Write-Error "Failed to revoke team member access to customer. $($call.message)"
            }
        }
    }
}