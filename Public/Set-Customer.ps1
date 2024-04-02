<#
.SYNOPSIS
Update customer information.

.DESCRIPTION
Updates information on a customer environment. Only values to update need to be specified.
All fields except Name can be set empty or null.

.INPUTS
PSCustomObject
Customer object returned from Get-Customer.

.OUTPUTS
PSCustomObject
Customer object with updated values.

.PARAMETER Id
The Mailhardener ID / UID of the customer.

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
The maximum number of domains the tenant is allowed to add to their account. If 0 (zero), the maximum domains is defined by the
package subscription (for regular Mailhardener customers) or unlimited for MSP tenants.

.PARAMETER RequireMfa
The requirement for 2FA (Two-Factor Authentication):
- 0: REQUIRE_2FA_NEVER
- 1: REQUIRE_2FA_ACCOUNT_ADMIN
- 2: REQUIRE_2FA_DOMAIN_ADMIN
- 3: REQUIRE_2FA_ALWAYS

.LINK
https://api.mailhardener.com/docs/#/paths/customer-customer_uid/post

.EXAMPLE
Set-Customer -Id "12345" -Name "Acme Corp" -CountryCode "US" -City "New York" -PostalCode "12345" -Address1 "123 Main St" -VatId "123456789" -MaxDomains 10 -RequireMfa 2

.EXAMPLE
$customer = Get-Customer -Id "1234567890"
$customer.Name = "Contoso, Inc."
$customer.MaxDomains = 30
$customer | Set-Customer

#>
function Set-Customer {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('uid', 'customer_uid')]
        [string]$Id,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
    
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('external_id')]
        [string]$ExternalId,
    
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('address_1')]
        [string]$Address1,
    
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('address_2')]
        [string]$Address2,
    
        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$City,
    
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('postal_code')]
        [string]$PostalCode,
    
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('country')]
        [ValidateLength(2, 5)]
        [string]$CountryCode,
    
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('vat_id')]
        [string]$VatId,
    
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('invoice_email')]
        [ValidateScript({ $_ -match '^\S+@\S+\.\S{2,}$' }, ErrorMessage = '"{0}" does not appear to be a valid email address.')]
        [string]$InvoiceEmail,
    
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('invoice_po')]
        [string]$InvoicePo,
    
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateRange(0, 1000)]
        [Alias('max_domains')]
        [int]$MaxDomains,
    
        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('require_2fa')]
        [ValidateRange(0, 3)]
        [int]$RequireMfa
    )
    process {
        # Only update fields with values, but allow null / empty values to update
        $body = @{}
        if ($PSBoundParameters.ContainsKey('Name'))         { $body.name          = $Name }
        if ($PSBoundParameters.ContainsKey('ExternalId'))   { $body.external_id   = $ExternalId }
        if ($PSBoundParameters.ContainsKey('Address1'))     { $body.address_1     = $Address1 }
        if ($PSBoundParameters.ContainsKey('Address2'))     { $body.address_2     = $Address2 }
        if ($PSBoundParameters.ContainsKey('City'))         { $body.city          = $City }
        if ($PSBoundParameters.ContainsKey('PostalCode'))   { $body.postal_code   = $PostalCode }
        if ($PSBoundParameters.ContainsKey('CountryCode'))  { $body.country       = $CountryCode }
        if ($PSBoundParameters.ContainsKey('VatId'))        { $body.vat_id        = $VatId }
        if ($PSBoundParameters.ContainsKey('InvoiceEmail')) { $body.invoice_email = $InvoiceEmail }
        if ($PSBoundParameters.ContainsKey('InvoicePo'))    { $body.invoice_po    = $InvoicePo }
        if ($PSBoundParameters.ContainsKey('MaxDomains'))   { $body.max_domains   = $MaxDomains }
        if ($PSBoundParameters.ContainsKey('RequireMfa'))   { $body.require_2fa   = $RequireMfa }
        
        $bodyJson = $body | ConvertTo-Json
        if ($PSCmdlet.ShouldProcess("Update customer $Id with the following properties: $bodyJson", "Update customer may overwrite or empty existing properties. Values to update: $bodyJson", "Update customer $Id")) {
            $call = Invoke-MailhardenerPOSTRequest -Endpoint "customer/$Id" -Body $body
            if ($call.result -eq 'success') {
                Write-Verbose "Successfully updated customer $($call.data.uid) / $($call.data.name)."
                $call.data
            }
            else {
                Write-Error "Failed to update customer. Error: $($call.message)"
            }
        }
    }
}