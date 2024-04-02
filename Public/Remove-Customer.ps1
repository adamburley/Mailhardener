<#
.SYNOPSIS
Delete a customer environment.

.DESCRIPTION
This will remove a customer, and its environment. A customer can only be deleted if all domains are removed from
the customer (tenant) environment.

.INPUTS
PSCustomObject
Customer object returned from Get-Customer.

.OUTPUTS
None

.PARAMETER Id
The Mailhardener ID / UID of the customer to remove.

.LINK
https://api.mailhardener.com/docs/#/paths/customer-customer_uid/delete

.EXAMPLE
Remove-Customer -Id "1234567890"

.EXAMPLE
$customer | Remove-Customer

.EXAMPLE
Remove-Customer -Id "1234567890" -Confirm:$false
# Remove a customer without prompting.

#>
function Remove-Customer {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('uid','customer_uid')]
        [string]$Id
    )
    process {
        if ($PSCmdlet.ShouldProcess("Customer $Id", "Remove customer environment from Mailhardener")) {
            $call = Invoke-MailhardenerDELETERequest -Endpoint "customer/$Id"
            if ($call.result -eq 'success') {
                Write-Verbose "Successfully removed customer $Id from Mailhardener."
            }
            else {
                Write-Error "Failed to remove customer. $($call.message)"
            }
        }
    }
}