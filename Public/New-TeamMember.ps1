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