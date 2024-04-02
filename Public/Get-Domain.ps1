<#
.SYNOPSIS
Returns the details of domain.

.DESCRIPTION
The Get-Domain function retrieves domain information from the Mailhardener service based on the provided parameters. It can retrieve information for a specific domain or for all domains associated with a customer.

.PARAMETER CustomerId
Specifies the unique identifier of the customer whose domain information needs to be retrieved.

.PARAMETER Name
Specifies the name of the domain for which information needs to be retrieved. If not provided, information for all domains associated with the customer will be retrieved.

.OUTPUTS
The function outputs a PSCustomObject or an array of PSCustomObjects representing the retrieved domain information.

.EXAMPLE
Get-Domain -CustomerId "12345" -Name "example.com"
Retrieves information for the domain "example.com" associated with the customer with the ID "12345".

.EXAMPLE
Get-Domain -CustomerId "12345"
Retrieves information for all domains associated with the customer with the ID "12345".
#>

function Get-Domain {
    [CmdletBinding()]
    [OutputType([PSCustomObject], [PSCustomObject[]])]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('uid', 'customer_uid')]
        [string]$CustomerId,

        [Parameter()]
        [string]$Name
    )
    process {
        if ($Name) {
            Invoke-MailhardenerGETRequest -Endpoint "customer/$CustomerId/domain/$Name"
        }
        else {
            Invoke-MailhardenerGETRequest -Endpoint "customer/$CustomerId/domain" -All
        }    
    }
}