<#
.SYNOPSIS
Get customer information.

.DESCRIPTION
Returns a single customer or list of all customers (tenants) managed by this MSP.

.PARAMETER Id
The Mailhardener ID / UID of the customer to retrieve. This parameter is optional.
If not provided, all customers will be retrieved.

.OUTPUTS
PSCustomObject
PSCustomObject[]
The customer object(s) that were retrieved.

.LINK
https://api.mailhardener.com/docs/#/paths/customer/get

.EXAMPLE
Get-Customer -Id '1234567890'
Retrieves the customer with ID '1234567890'.

.EXAMPLE
Get-Customer
Retrieves all customers from Mailhardener.

#>

function Get-Customer {
    [CmdletBinding()]
    [OutputType([PSCustomObject], [PSCustomObject[]])]
    param(
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('uid', 'customer_uid')]
        [string]$Id
    )
    process {
        if ($Id) {
            Invoke-MailhardenerGETRequest -Endpoint "customer/$Id"
        }
        else {
            Invoke-MailhardenerGETRequest -Endpoint 'customer' -All
        }    
    }
}