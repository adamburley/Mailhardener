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