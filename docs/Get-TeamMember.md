---
external help file: Mailhardener-help.xml
Module Name: Mailhardener
online version: https://api.mailhardener.com/docs/#/paths/customer-customer_uid--domain--domain_name--dmarc_aggregate_reports/get
schema: 2.0.0
---

# Get-TeamMember

## SYNOPSIS
Retrieves team member information from the Mailhardener API.

## SYNTAX

```
Get-TeamMember [-CustomerId] <String> [[-Id] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Get a list of team members for a specific customer or retrieve a specific team member by ID.

## EXAMPLES

### EXAMPLE 1
```
Get-TeamMember -CustomerId "1234567890" -Id "0987654321"
```

### EXAMPLE 2
```
Get-TeamMember -CustomerId "1234567890"
Retrieves all team members for the specified custoemr
```

## PARAMETERS

### -CustomerId
Mailhardener ID / EID for the desired customer.

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
Team member Mailhardener ID / EID.
If specified, only the team member with the matching ID will be retrieved.

```yaml
Type: String
Parameter Sets: (All)
Aliases: uid, team_member_uid

Required: False
Position: 2
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
### PSCustomObject[]
## NOTES

## RELATED LINKS
