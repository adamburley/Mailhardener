<#
.SYNOPSIS
Add a domain to a customer in Mailhardener.

.DESCRIPTION
Removes a domain from this customer.
Note: before domain is removed, all DNS entries related to Mailhardener must be removed.

.PARAMETER CustomerId
The unique identifier of the customer.

.PARAMETER Name
The name of the domain to be removed.

.EXAMPLE
Remove-Domain -CustomerId "1234567890" -Name "example.com"

.EXAMPLE
$customer = Get-Customer -Id "1234567890"
$customer | Remove-Domain -Name "example.com"

#>
function Remove-Domain {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('uid', 'customer_uid')]
        [string]$CustomerId,

        [Parameter(Mandatory)]
        [string]$Name
    )
    if ($PSCmdlet.ShouldProcess("Domain $Name under customer $CustomerId", "Remove domain from customer")) {
        $call = Invoke-MailhardenerDELETERequest -Endpoint "customer/$CustomerId/domain/$Name"
        if ($call.result -eq 'success') {
            Write-Verbose "Successfully removed domain $Name."
        }
        else {
            Write-Error "Failed to remove domain. Error: $($call.message)"
        }
    }
}