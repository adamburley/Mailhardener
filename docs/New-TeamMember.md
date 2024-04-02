---
external help file: Mailhardener-help.xml
Module Name: Mailhardener
online version: https://api.mailhardener.com/docs/#/paths/customer-customer_uid--team_member/post
schema: 2.0.0
---

# New-TeamMember

## SYNOPSIS
Invite a new team member user under the specificed customer in Mailhardener.

## SYNTAX

### AllDomains (Default)
```
New-TeamMember -CustomerId <String> -Name <String> -Email <String> [-ReceiveDNSAlerts] [-ReceiveNewsletter]
 [-ReceiveAggregateReports <String>] [-Role <String>] [-AllDomains] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### SpecificDomains
```
New-TeamMember -CustomerId <String> -Name <String> -Email <String> [-ReceiveDNSAlerts] [-ReceiveNewsletter]
 [-ReceiveAggregateReports <String>] [-Role <String>] [-Domains <String[]>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Invites a new or existing team member (user) in Mailhardener
Default permissions are view-only access to all domains managed by the customer.
On success, an email invitation is sent to the email address specified and the new user object is returned.

## EXAMPLES

### EXAMPLE 1
```
New-TeamMember -Name "John Doe" -Email "johndoe@example.com" -ReceiveDNSAlerts -ReceiveNewsletter -ReceiveAggregateReports "Monthly" -Role "DomainAdmin" -Domains "example.com", "example.org"
Creates a new team member named "John Doe" with the email address "johndoe@example.com". The user will receive DNS change notifications, feature updates, and monthly aggregate reports via email. The user has the role of Domain Admin and has access to the "example.com" and "example.org" domains.
```

## PARAMETERS

### -CustomerId
The Mailhardener ID / UID of the customer to create the team member under.

```yaml
Type: String
Parameter Sets: (All)
Aliases: customer_uid

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Display name for the user.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Email
Email address of the user.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReceiveDNSAlerts
Indicates whether the user has opted in to receive DNS change notifications via email.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: dns_alerts

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReceiveNewsletter
Indicates whether the user has opted in to receive feature updates on Mailhardener.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: newsletter

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReceiveAggregateReports
Specifies the type of aggregate reports the user wants to receive.
Valid values are:
- 'None': User opted out of receiving monthly aggregate reports via email.
- 'Monthly': User opted in to receive monthly aggregate reports via email.

```yaml
Type: String
Parameter Sets: (All)
Aliases: aggregate_reports

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Role
Specifies the role of the user.
Valid values are:
- 'AccountAdmin': Account admin, has full control over the entire team, including user management and billing.
- 'DomainAdmin': Domain admin, has control over a specific domain.
- 'DomainViewer': Domain viewer, has read-only access to a specific domain.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 3
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllDomains
If true, this team member has access to all domains managed by the customer.
If not desired, use -Domains to specify the
subset of domains this team member has access to.

```yaml
Type: SwitchParameter
Parameter Sets: AllDomains
Aliases: all_domains

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Domains
Limited list of domains this team member is delegated access to.

```yaml
Type: String[]
Parameter Sets: SpecificDomains
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### PSCustomObject
### Object representing the newly created team member.
## NOTES

## RELATED LINKS

[https://api.mailhardener.com/docs/#/paths/customer-customer_uid--team_member/post](https://api.mailhardener.com/docs/#/paths/customer-customer_uid--team_member/post)

