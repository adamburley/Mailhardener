---
external help file: Mailhardener-help.xml
Module Name: Mailhardener
online version: https://api.mailhardener.com/docs/#/paths/customer-customer_uid/post
schema: 2.0.0
---

# Set-TeamMember

## SYNOPSIS
Update a customer team member.

## SYNTAX

```
Set-TeamMember [-CustomerId] <String> [-Id] <String> [[-Name] <String>] [[-Email] <String>]
 [[-ReceiveDNSAlerts] <Boolean>] [[-ReceiveNewsletter] <Boolean>] [[-ReceiveAggregateReports] <String>]
 [[-Role] <String>] [[-AllDomains] <Boolean>] [[-Domains] <String[]>] [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Update a customer team member in Mailhardener.
Supports changing scope, role, and notification preferences.
Only values to update need to be specified.
All fields except Name and Email can be set empty or null.

## EXAMPLES

### EXAMPLE 1
```
Set-TeamMember -CustomerId "12345" -Id "67890" -Name "John Doe" -Email "johndoe@example.com" -ReceiveDNSAlerts $true -ReceiveNewsletter $true -ReceiveAggregateReports "Monthly" -Role "DomainAdmin" -AllDomains $false -Domains @("example.com", "example.org")
```

This example updates the properties of a team member with the specified CustomerId and Id.
It sets the name, email address, notification preferences, role, and domain access for the team member.

## PARAMETERS

### -CustomerId
The Mailhardeber ID / UID of the customer to update the team member under.

```yaml
Type: String
Parameter Sets: (All)
Aliases: customer_uid

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
The Mailhardener ID / UID of the team member to update.

```yaml
Type: String
Parameter Sets: (All)
Aliases: team_member_uid, uid

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
The name of the user.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Email
Email address of the user.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ReceiveDNSAlerts
Indicates whether the user has opted in to receive DNS change notifications via email.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases: dns_alerts

Required: False
Position: 5
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ReceiveNewsletter
Indicates whether the user has opted in to receive feature updates on Mailhardener.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases: newsletter

Required: False
Position: 6
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ReceiveAggregateReports
Specifies the frequency of receiving aggregate reports via email.
Valid values are:
- 'None': User opted out of receiving monthly aggregate reports via email.
- 'Monthly': User opted in to receive monthly aggregate reports via email.

```yaml
Type: String
Parameter Sets: (All)
Aliases: aggregate_reports

Required: False
Position: 7
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Role
Specifies the role of the team member.
Valid values are:
- 'AccountAdmin': Account admin, has full control over the entire team, including user management and billing.
- 'DomainAdmin': Domain admin, has control over a specific domain managed by the customer.
- 'DomainViewer': Domain viewer, has read-only access to a specific domain managed by the customer.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -AllDomains
If true, this team member has access to all domains managed by the customer.
If false, the Domains parameter should be provided to specify a limited list of domains.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases: all_domains

Required: False
Position: 9
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Domains
List of domains, by name, that this team member has access to.
Only included if AllDomains is false.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
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

### PSCustomObject
### Object representing the team member to update.
## OUTPUTS

### PSCustomObject
### Object representing the updated team member.
## NOTES
Author: GitHub Copilot

## RELATED LINKS
