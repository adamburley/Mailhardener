<#
.SYNOPSIS
Create a new customer environment

.DESCRIPTION
This creates a new customer, which receives its own Mailhardener environment.
Each customer environment receives its own reporting endpoint (the rua value in the DMARC and SMTP TLS reporting DNS records).

.INPUTS
None

.OUTPUTS
PSCustomObject
The customer object that was created.

.PARAMETER Name
The name of the customer.

.PARAMETER ExternalId
The customer (tenant) identifier assignable by the MSP.

.PARAMETER Address1
The first line of the customer's address.

.PARAMETER Address2
The second line of the customer's address.

.PARAMETER City
The city of the customer's address.

.PARAMETER PostalCode
The postal code of the customer's address.

.PARAMETER CountryCode
The ISO3166-2 country code of the customer's address.

.PARAMETER VatId
The VAT-id of the customer (tenant) organization.

.PARAMETER InvoiceEmail
The invoice email address for the customer (not applicable for MSP tenants).

.PARAMETER InvoicePo
The Purchase Order number for invoicing (not applicable for MSP tenants).

.PARAMETER MaxDomains
The maximum number of domains the tenant is allowed to add to their account. If not defined or 0, the maximum is defined by the
package subscription (for regular Mailhardener customers) or unlimited for MSP tenants.

.PARAMETER RequireMfa
The requirement for two-factor authentication (2FA) for the customer. Valid values are:
- 0: REQUIRE_2FA_NEVER - Never require 2FA
- 1: REQUIRE_2FA_ACCOUNT_ADMIN - Require 2FA for account administrators
- 2: REQUIRE_2FA_DOMAIN_ADMIN - Require 2FA for domain administrators
- 3: REQUIRE_2FA_ALWAYS - Always require 2FA [Default]

.OUTPUTS
[PSCustomObject]
The customer object that was created.

.LINK
https://api.mailhardener.com/docs/#/paths/customer/post

.EXAMPLE
New-Customer -Name "Example Customer" -ExternalId "12345" -Address1 "123 Main St" -City "New York" -PostalCode "10001" -CountryCode "US" -VatId "123456789" -InvoiceEmail "example@example.com" -InvoicePo "PO12345" -MaxDomains 10 -RequireMfa 2

.EXAMPLE
New-Customer -Name "Contoso, Inc."
# Minimum required information

#>
function New-Customer {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter()]
        [Alias('external_id')]
        [string]$ExternalId,

        [Parameter()]
        [Alias('address_1')]
        [string]$Address1,

        [Parameter()]
        [Alias('address_2')]
        [string]$Address2,

        [Parameter()]
        [string]$City,

        [Parameter()]
        [Alias('postal_code')]
        [string]$PostalCode,

        [Parameter()]
        [Alias('country')]
        [ValidateLength(2, 5)]
        [string]$CountryCode,

        [Parameter()]
        [Alias('vat_id')]
        [string]$VatId,

        [Parameter()]
        [Alias('invoice_email')]
        [ValidateScript({ $_ -match '^\S+@\S+\.\S{2,}$' }, ErrorMessage = '"{0}" does not appear to be a valid email address.')]
        [string]$InvoiceEmail,

        [Parameter()]
        [Alias('invoice_po')]
        [string]$InvoicePo,

        [Parameter()]
        [Alias('max_domains')]
        [ValidateRange(0, 1000)]
        [int]$MaxDomains,

        [Parameter()]
        [Alias('require_2fa')]
        [ValidateRange(0, 3)]
        [int]$RequireMfa = 3
    )
    $body = @{
        name          = $Name
        external_id   = $ExternalId
        address_1     = $Address1
        address_2     = $Address2
        city          = $City
        postal_code   = $PostalCode
        country       = $CountryCode
        vat_id        = $VatId
        invoice_email = $InvoiceEmail
        invoice_po    = $InvoicePo
        max_domains   = $MaxDomains -eq 0 ? $null : $MaxDomains
        require_mfa   = $RequireMfa
    }
    $bodyJson = $body | ConvertTo-Json
    if ($PSCmdlet.ShouldProcess("Create new customer with the following properties: $bodyJson")) {
        $call = Invoke-MailhardenerPOSTRequest -Endpoint 'customer' -Body $body
        if ($call.result -eq 'success') {
            Write-Host "Successfully created customer $($call.data.name). Reporting endpoint: " -NoNewline
            Write-Host "$(Show-ReportingEndpoint -Id $call.data.uid)" -ForegroundColor Cyan
            $call.data
        }
        else {
            Write-Error "Failed to create customer. Error: $($call.message)"
        }
    }
}