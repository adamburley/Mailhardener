<#
.SYNOPSIS
Add a domain to a customer in Mailhardener.

.DESCRIPTION
Creates a claim on a domain for this customer. Once DMARC or SMTP TLS reporting DNS record is detected for this customer
environment, the domain will become validated.
When adding a domain, only the name can be set. All other properties of the domain are automatically discovered by Mailhardener.

.PARAMETER CustomerId
The customer Mailhardener ID / UID.

.PARAMETER Name
The domain name to add.

.INPUTS
PSCustomObject
Customer Object

.OUTPUTS
PSCustomObject
Returns the newly added domain. Note that not all DNS properties of the domain may be detected at this point.

.LINK
https://api.mailhardener.com/docs/#/paths/customer-customer_uid--domain/post

.EXAMPLE
New-Domain -CustomerId "1234567890" -Name "example.com"

.EXAMPLE
$customer = Get-Customer -Id "1234567890"
$customer | New-Domain -Name "example.com"

#>
function New-Domain {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('uid', 'customer_uid')]
        [string]$CustomerId,

        [Parameter(Mandatory)]
        [string]$Name
    )
    $body = @{
        name = $Name
    }
    $call = Invoke-MailhardenerPOSTRequest -Endpoint "customer/$CustomerId/domain" -Body $body
    if ($call.result -eq 'success') {
        Write-Verbose "Successfully created domain $($call.data.name)."
        $call.data
    }
    else {
        Write-Error "Failed to create domain. Error: $($call.message)"
    }
}