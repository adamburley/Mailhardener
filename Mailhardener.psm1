function Invoke-MailhardenerDELETERequest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Endpoint
    )

    try {
        if (Get-MailhardenerToken) {
        $headers = @{
            'Authorization' = "Bearer $MailhardenerAccessToken"
            'Accept'      = 'application/json'
        }

        Write-Debug "Sending DELETE request to $Endpoint."

        $response = Invoke-WebRequest -Uri "https://api.mailhardener.com/v1/$Endpoint" -Method Delete -Headers $headers -SkipHttpErrorCheck
        if ($response.StatusCode -eq 200) {
            Write-Debug "Successfully sent DELETE request to $Endpoint."
            $response.Content | ConvertFrom-Json
        }
        else {
            # Returns - 403 for an invalid or out of scope uid, 404 for a general failure, 500 for a server error
            Write-Debug "Failed to send DELETE request to $Endpoint. Response: $($response.StatusCode) - $($response.StatusDescription) $($response.Content)"
            $response.Content | ConvertFrom-Json
        }
    } else {
        [PSCustomObject]@{
            result = 'failure'
            message= 'Not connected to API'
        }
    }
    }
    catch {
        Write-Error "Failed to send DELETE request to $Endpoint`: $_"
    }
}
function Invoke-MailhardenerGETRequest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Endpoint,

        [Parameter()]
        [string]$Customer,

        [Parameter()]
        [string]$Limit = 50,

        [Parameter()]
        [string]$Offset = 0,

        [Parameter()]
        [switch]$All,

        [Parameter()]
        [hashtable]$Parameters = @{}
    )
    if (Get-MailhardenerToken) {
        $headers = @{
            'Authorization' = "Bearer $MailhardenerAccessToken"
            'Accept'        = 'application/json'
        }
        $Parameters.Add('_limit', $Limit)
        $Parameters.Add('_offset', $Offset)

        # Loop to get all results if paginated
        $currentResults = 0
        $totalResults = -1
        while ($currentResults -ne $totalResults) {
            $call = Invoke-RestMethod -Uri "https://api.mailhardener.com/v1/$Endpoint" -Method Get -Headers $headers -Body $Parameters
            if ($call.result -eq 'success') {
                if ($call.data -isnot [array]) {
                    $call.data
                    break
                }
                $currentResults += $call.data.Count
                $totalResults = $call.total
                Write-Verbose "Retrieved $($call.data.Count) records from /$Endpoint, of $totalResults total."
                if ($call.data.Count -ne $totalResults -and -not $All) {
                    Write-Warning "Only the first $Limit records were retrieved. Use -All to retrieve all records."
                    $call.data
                    break
                }
                $Parameters._offset = $currentResults
                $call.data
            }
            else {
                Write-Error "Failed to retrieve data from /$Endpoint. Error: $($call.message)"
                break
            }
 
        }
    }
}
function Invoke-MailhardenerPOSTRequest {
    param (
        [Parameter(Mandatory)]
        [string]$Endpoint,

        [Parameter(Mandatory)]
        [hashtable]$Body
    )
    if (Get-MailhardenerToken) {
        $headers = @{
            'Authorization' = "Bearer $MailhardenerAccessToken"
            'Content-Type'  = 'application/json'
            'Accept'        = 'application/json'
        }

        try {
            $response = Invoke-RestMethod -Uri "https://api.mailhardener.com/v1/$Endpoint" -Method Post -Body ($Body | ConvertTo-Json -Compress) -Headers $headers
            return $response
        }
        catch {
            Write-Error $_.Exception.Message
        }
    } else {
        return [PSCustomObject]@{
            result  = 'error'
            message = 'Not connected to API'}
    }
}
<#
.SYNOPSIS
Connect to the Mailhardener API for MSP usage

.DESCRIPTION
Accepts an Oauth2 client ID and secret and requests a session token from the Mailhardener API. On success, an access token is stored in memory for use in subsequent calls.

.PARAMETER ClientID
Client ID

.PARAMETER ClientSecret
Client secret

.LINK
https://www.mailhardener.com/dashboard/team

.LINK
https://api.mailhardener.com/docs/#/paths/session-action-access_token/post

.EXAMPLE
Connect-Mailhardener -ClientID 'your_client_id' -ClientSecret 'your_client_secret'

.NOTES
Oauth token lifetime is 30 days.

#>
function Connect-Mailhardener {
    [CmdletBinding()]
    [OutputType([System.Void])]
    param(
        [Parameter(Mandatory)]
        [Alias("client_id")]
        [string]$ClientID,

        [Parameter(Mandatory)]
        [Alias("client_secret")]
        [string]$ClientSecret
    )
    $splat = @{
        Method  = 'POST'
        Uri     = 'https://api.mailhardener.com/v1/session/action/access_token'
        Headers = @{
            'Accept'       = 'application/json'
            'Content-Type' = 'application/x-www-form-urlencoded'
        }
        Body    = @{
            'client_id'     = $ClientID
            'client_secret' = $ClientSecret
            'grant_type'    = 'client_credentials'
        }
    }
    Write-Debug "HTTP request: $($splat | ConvertTo-Json)"
    $call = Invoke-WebRequest @splat -SkipHttpErrorCheck
    Write-Debug "HTTP response: $($call | Select-Object StatusCode, StatusDescription, Content | ConvertTo-Json)"
    $response =  $call.Content | ConvertFrom-Json
    if ($response.access_token) {
        Write-Host "Successfully connected to Mailhardener." -ForegroundColor Green
        Set-Variable -Name 'MailhardenerAccessToken' -Value $response.access_token -Scope Script -Visibility Private
    }
    else {
        Write-Error "Failed to connect to Mailhardener. $($response.message)"
    }
}
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
<#
.SYNOPSIS
Retrieve reports from the Mailhardener API.

.DESCRIPTION
Retrieves DMARC aggregate, failure, or SMTPTLS reports for a specific domain from Mailhardener.
The API always returns reports for 7 days for DMARC aggregate or 14 days for DMARC failure and SMTP TLS
reports, regardless of the number of reports that would result in. Use the -TotalDays parameter to automatically
paginate and retrieve additional records.

Each call takes 10+ seconds to complete, so be patient when retrieving large amounts of data.

.INPUTS
None

.OUTPUTS
PSCustomObject[]
# Array of objects each representing a single report. See API documentation pages under .LINK for specific formats.

.PARAMETER CustomerId
Customer Mailhardener ID / UID

.PARAMETER DomainName
Domain name to retrieve reports for.

.PARAMETER Type
The type of report to retrieve. Valid values are 'Aggregate', 'Failure', and 'SMTPTLS'.

.PARAMETER From
The starting (most recent) date of the report data to retrieve. Must be in the format yyyy-MM-dd.
Default value is the current date.

.PARAMETER TotalDays
The total number of days of report data to retrieve. Default is the minimum for the report type.

.LINK
https://api.mailhardener.com/docs/#/paths/customer-customer_uid--domain--domain_name--dmarc_aggregate_reports/get

.LINK
https://api.mailhardener.com/docs/#/paths/customer-customer_uid--domain--domain_name--dmarc_failure_reports/get

.LINK
https://api.mailhardener.com/docs/#/paths/customer-customer_uid--domain--domain_name--smtp_tls_reports/get

.EXAMPLE
Get-EmailReport -CustomerId "1234567890" -DomainName "example.com" -Type "Aggregate"
# Returns DMARC aggregate reports for the last 7 days.

.EXAMPLE
Get-EmailReport -CustomerId "1234567890" -DomainName "example.com" -Type "Failure" -TotalDays 60
# Returns DMARC failure reports for the last 60 days.
 
.EXAMPLE
Get-EmailReport -CustomerId "12345" -DomainName "example.com" -Type "SMTPTLS" -From "2024-07-01" -TotalDays 60
# Returns SMTP TLS reports for the period May 2, 2024 - July 1, 2024.

#>
function Get-EmailReport {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Alias('customer_uid')]
        [string]$CustomerId,

        [Parameter(Mandatory)]
        [Alias('domain_name')]
        [string]$DomainName,

        [Parameter(Mandatory)]
        [ValidateSet('Aggregate', 'Failure', 'SMTPTLS')]
        [string]$Type,

        [Parameter()]
        [ValidateScript({ $_ -match '20\d\d-[0-1]\d-[0-3]\d' }, ErrorMessage = 'From must be in the format yyyy-MM-dd.')]
        [string]$From,

        [Parameter()]
        [ValidateRange(7, 366)]
        [int]$TotalDays
    )
    $minimumDaySpan = 7
    switch ($Type) {
        'Aggregate' { $reportType = 'dmarc_aggregate_reports' }
        'Failure' { 
            $reportType = 'dmarc_failure_reports'
            $minimumDaySpan = 14
        }
        'SMTPTLS' {
            $reportType = 'smtp_tls_reports'
            $minimumDaySpan = 14
        }
    }
    $uri = "https://api.mailhardener.com/v1/customer/$CustomerId/domain/$DomainName/$reportType"
    $headers = @{
        'Authorization' = "Bearer $MailhardenerAccessToken"
        'Accept'        = 'application/json'
    }
    if ($From) { $Parameters = @{ from = $From } } else { $Parameters = @{} }
    $dayCounter = 0
    do {
        Write-Debug "Retrieving report data. URI: $uri, Parameters: $($PSBoundParameters | ConvertTo-Json -Compress)"
        $call = Invoke-WebRequest -Uri $uri -Method Get -Headers $headers -Body $Parameters -SkipHttpErrorCheck
        if ($call.StatusCode -ne 200) {
            Write-Debug "Failed to retrieve data from $uri. $($call.StatusCode) $($call.StatusDescription) $($call.Content)"
        }
        $call = $call.Content | ConvertFrom-Json
        if ($call.result -eq 'success') {
            if ($call.data.Count -eq 0) {
                Write-Warning "No data found for $CustomerId $DomainName $Type $From"
                break
            }
            if ($call.data -isnot [array]) {
                $call.data
                break
            }
            $dates = $call.data.date | Select-Object -Unique | Sort-Object
            $dayCounter += $dates.count
            Write-Debug "Current call contains $($dates.count) days. New total days: $dayCounter."
            $fromDate = $dates[0]
            $toDate = $dates[-1]

            Write-Host "Retrieved $($call.data.Count) $Type reports for $DomainName, covering $($dates.count) days from $fromDate to $toDate." -ForegroundColor Yellow
            
            # Output this data
            $call.data

            # Queue up the next batch
            $Parameters.from = (Get-date -Date $fromDate).AddDays(-1).ToString('yyyy-MM-dd')
        }
        else {
            Write-Error "Failed to retrieve data from $uri. Error: $($call.message)"
            break
        }
    } while ($dates.Count -eq $minimumDaySpan -and $dayCounter -lt $TotalDays)
    Write-Host "Retrieved a total of $dayCounter days of $Type reports for $DomainName." -ForegroundColor Green
}
<#
.SYNOPSIS
Returns current Mailhardener access token.

.DESCRIPTION
Returns the current Oauth2 access token for use with direct API calls.

.INPUTS
None

.OUTPUTS
System.String

.EXAMPLE
Get-MailhardenerToken

#>
function Get-MailhardenerToken {
    if ($null -eq $Script:MailhardenerAccessToken) {
        Write-Warning "Mailhardener access token not found. Please run Connect-Mailhardener."
    }
    else {    
        return $script:MailhardenerAccessToken
    }
}
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
<#
.SYNOPSIS
Invite a new team member user under the specificed customer in Mailhardener.

.DESCRIPTION
Invites a new or existing team member (user) in Mailhardener
Default permissions are view-only access to all domains managed by the customer.
On success, an email invitation is sent to the email address specified and the new user object is returned.

.OUTPUTS
PSCustomObject
Object representing the newly created team member.

.PARAMETER CustomerId
The Mailhardener ID / UID of the customer to create the team member under.

.PARAMETER Name
Display name for the user.

.PARAMETER Email
Email address of the user.

.PARAMETER ReceiveDNSAlerts
Indicates whether the user has opted in to receive DNS change notifications via email.

.PARAMETER ReceiveNewsletter
Indicates whether the user has opted in to receive feature updates on Mailhardener.

.PARAMETER ReceiveAggregateReports
Specifies the type of aggregate reports the user wants to receive. Valid values are:
- 'None': User opted out of receiving monthly aggregate reports via email.
- 'Monthly': User opted in to receive monthly aggregate reports via email.

.PARAMETER Role
Specifies the role of the user. Valid values are:
- 'AccountAdmin': Account admin, has full control over the entire team, including user management and billing.
- 'DomainAdmin': Domain admin, has control over a specific domain.
- 'DomainViewer': Domain viewer, has read-only access to a specific domain.

.PARAMETER AllDomains
If true, this team member has access to all domains managed by the customer. If not desired, use -Domains to specify the
subset of domains this team member has access to.

.PARAMETER Domains
Limited list of domains this team member is delegated access to.

.LINK
https://api.mailhardener.com/docs/#/paths/customer-customer_uid--team_member/post

.EXAMPLE
New-TeamMember -Name "John Doe" -Email "johndoe@example.com" -ReceiveDNSAlerts -ReceiveNewsletter -ReceiveAggregateReports "Monthly" -Role "DomainAdmin" -Domains "example.com", "example.org"
Creates a new team member named "John Doe" with the email address "johndoe@example.com". The user will receive DNS change notifications, feature updates, and monthly aggregate reports via email. The user has the role of Domain Admin and has access to the "example.com" and "example.org" domains.

#>
function New-TeamMember {
    [CmdletBinding(DefaultParameterSetName = 'AllDomains',SupportsShouldProcess,ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory)]
        [Alias('customer_uid')]
        [string]$CustomerId,

        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [ValidateScript({ $_ -match '^\S+@\S+\.\S{2,}$' }, ErrorMessage= '"{0}" does not appear to be a valid email address.')]
        [string]$Email,

        [Parameter()]
        [Alias('dns_alerts')]
        [switch]$ReceiveDNSAlerts,

        [Parameter()]
        [Alias('newsletter')]
        [switch]$ReceiveNewsletter,

        [Parameter()]
        [Alias('aggregate_reports')]
        [ValidateSet('None', 'Monthly', 0, 1)]
        [string]$ReceiveAggregateReports = 0,

        [Parameter()]
        [ValidateSet('AccountAdmin', 'DomainAdmin', 'DomainViewer', 1, 2, 3)]
        [string]$Role = 3,

        [Parameter(ParameterSetName = 'AllDomains')]
        [Alias('all_domains')]
        [switch]$AllDomains,

        [Parameter(ParameterSetName = 'SpecificDomains')]
        [ValidateScript( { $_ -match '^\S+\.\S+$' }, ErrorMessage= '"{0}" does not appear to be a valid domain name.')]
        [string[]]$Domains
    )
    process {
        $body = @{
            name              = $Name
            email             = $Email
            dns_alerts        = [bool]$ReceiveDNSAlerts
            newsletter        = [bool]$ReceiveNewsletter
            role              = switch ($Role) {
                'AccountAdmin' { 1 }
                'DomainAdmin' { 2 }
                'DomainViewer' { 3 }
                default { $Role }
            }
            aggregate_reports = switch ($ReceiveAggregateReports) {
                'None' { 0 }
                'Monthly' { 1 }
                default { $ReceiveAggregateReports }
            }
        }
        if ($PSCmdlet.ParameterSetName -eq 'AllDomains') {
            $body.all_domains = $true
        }
        else {
            $body.all_domains = $false
            $body.domains = $Domains
        }

        if ($PSCmdlet.ShouldProcess("Create team member user $Name ($Email) under customer $CustomerId with the following properties: $($body | ConvertTo-Json)", "Adding a team member will send an invite to the email address provided.", "Add team member $Name")) {
            $call = Invoke-MailhardenerPOSTRequest -Endpoint "customer/$CustomerId/team_member" -Body $body
            if ($call.result -eq 'success') {
                Write-Verbose "Successfully created team member $Name ($Email) under customer $CustomerId."
                $call.data
            }
            else {
                Write-Error "Failed to create team member $Name ($Email) under customer $CustomerId. Error: $($call.message)"
            }
        }
    }
}
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
<#
.SYNOPSIS
Update a customer team member.

.DESCRIPTION
Update a customer team member in Mailhardener. Supports changing scope, role, and notification preferences.
Only values to update need to be specified.
All fields except Name and Email can be set empty or null.

.INPUTS
PSCustomObject
Object representing the team member to update.

.OUTPUTS
PSCustomObject
Object representing the updated team member.

.PARAMETER CustomerId
The Mailhardeber ID / UID of the customer to update the team member under.

.PARAMETER Id
The Mailhardener ID / UID of the team member to update.

.PARAMETER Name
The name of the user.

.PARAMETER Email
Email address of the user.

.PARAMETER ReceiveDNSAlerts
Indicates whether the user has opted in to receive DNS change notifications via email.

.PARAMETER ReceiveNewsletter
Indicates whether the user has opted in to receive feature updates on Mailhardener.

.PARAMETER ReceiveAggregateReports
Specifies the frequency of receiving aggregate reports via email. Valid values are:
- 'None': User opted out of receiving monthly aggregate reports via email.
- 'Monthly': User opted in to receive monthly aggregate reports via email.

.PARAMETER Role
Specifies the role of the team member. Valid values are:
- 'AccountAdmin': Account admin, has full control over the entire team, including user management and billing.
- 'DomainAdmin': Domain admin, has control over a specific domain managed by the customer.
- 'DomainViewer': Domain viewer, has read-only access to a specific domain managed by the customer.

.PARAMETER AllDomains
If true, this team member has access to all domains managed by the customer. If false, the Domains parameter should be provided to specify a limited list of domains.

.PARAMETER Domains
List of domains, by name, that this team member has access to. Only included if AllDomains is false.

.EXAMPLE
Set-TeamMember -CustomerId "12345" -Id "67890" -Name "John Doe" -Email "johndoe@example.com" -ReceiveDNSAlerts $true -ReceiveNewsletter $true -ReceiveAggregateReports "Monthly" -Role "DomainAdmin" -AllDomains $false -Domains @("example.com", "example.org")

This example updates the properties of a team member with the specified CustomerId and Id. It sets the name, email address, notification preferences, role, and domain access for the team member.

.NOTES
Author: GitHub Copilot
#>
function Set-TeamMember {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [Alias('customer_uid')]
        [string]$CustomerId,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias('team_member_uid', 'uid')]
        [string]$Id,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateScript({ $_ -match '^\S+@\S+\.\S{2,}$' }, ErrorMessage= '"{0}" does not appear to be a valid email address.')]
        [string]$Email,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('dns_alerts')]
        [bool]$ReceiveDNSAlerts,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('newsletter')]
        [bool]$ReceiveNewsletter,

        [Parameter(ValueFromPipelineByPropertyName)]
        [Alias('aggregate_reports')]
        [ValidateSet('None', 'Monthly', 0, 1)]
        [string]$ReceiveAggregateReports,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet('AccountAdmin', 'DomainAdmin', 'DomainViewer', 1, 2, 3)]
        [string]$Role,

        [Parameter()]
        [Alias('all_domains')]
        [bool]$AllDomains,

        [Parameter()]
        [ValidateScript( { $_ -match '^\S+\.\S+$' }, ErrorMessage= '"{0}" does not appear to be a valid domain name.')]
        [string[]]$Domains
    )
    process {
        $body = @{}
        if ($PSBoundParameters.ContainsKey('Name')) { $body.name = $Name }
        if ($PSBoundParameters.ContainsKey('Email')) { $body.email = $Email }
        if ($PSBoundParameters.ContainsKey('ReceiveDNSAlerts')) { $body.dns_alerts = $ReceiveDNSAlerts }
        if ($PSBoundParameters.ContainsKey('ReceiveNewsletter')) { $body.newsletter = $ReceiveNewsletter }
        if ($PSBoundParameters.ContainsKey('ReceiveAggregateReports')) {
            $body.aggregate_reports = switch ($ReceiveAggregateReports) {
                'None' { 0 }
                'Monthly' { 1 }
                default { $ReceiveAggregateReports }
            }
        }
        if ($PSBoundParameters.ContainsKey('Role')) {
            $body.role = switch ($Role) {
                'AccountAdmin' { 1 }
                'DomainAdmin' { 2 }
                'DomainViewer' { 3 }
                default { $Role }
            }
        }
        if ($PSBoundParameters.ContainsKey('AllDomains')) { 
            $body.all_domains = $AllDomains 
            if ($AllDomains -eq $false -and -not $Domains) {
                Write-Warning "If you set AllDomains to false, you must provide a list of domains. Unless AllDomains is already false, this call will likely fail."
            }
        }
        if ($PSBoundParameters.ContainsKey('Domains')) {
            if ($body.all_domains) {
                Write-Warning "AllDomains is set to true. The Domains parameter will be ignored. Set AllDomains `$false to specify a limited list of domains."
            } else {
            $body.domains = $Domains
            }
        }
        $bodyJson = $body | ConvertTo-Json
        if ($PSCmdlet.ShouldProcess("Update team member $Id under customer $CustomerId with the following properties: $bodyJson", "Update team member may overwrite or empty existing properties. Values to update: $bodyJson", "Update team member $Id under customer $CustomerId")) {
            $call = Invoke-MailhardenerPOSTRequest -Endpoint "customer/$CustomerId/team_member/$Id" -Body $body
            if ($call.result -eq 'success') {
                Write-Verbose "Successfully updated team member $($call.data.uid) / $($call.data.name)."
                $call.data
            }
            else {
                Write-Error "Failed to update team member. Error: $($call.message)"
            }
        }
    }
}
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
