---
external help file: Mailhardener-help.xml
Module Name: Mailhardener
online version: https://api.mailhardener.com/docs/#/paths/customer-customer_uid--team_member--team_member_uid/delete
schema: 2.0.0
---

# Remove-TeamMember

## SYNOPSIS
Remove a team member from a customer's environment.

## SYNTAX

```
Remove-TeamMember [-CustomerId] <String> [-Id] <String> [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Revokes a team member user's access to a customer environment.
The user will receive an email notifying them of this change.

## EXAMPLES

### EXAMPLE 1
```
Remove-TeamMember -CustomerId "1234567890" -Id "0987654321"
```

### EXAMPLE 2
```
Get-TeamMember -CustomerId "1234567890" | Remove-TeamMember
# Removes all team members from customer 1234567890.
```

### EXAMPLE 3
```
Remove-TeamMember -CustomerId "1234567890" -Id "0987654321" -Confirm:$false
# Remove team member without confirmation.
```

## PARAMETERS

### -CustomerId
The Mailhardener ID / UID for the customer.

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
The Mailhardener ID / UID for the team member.

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
### Team member object from Get-TeamMember.
## OUTPUTS

### None
## NOTES

## RELATED LINKS

[https://api.mailhardener.com/docs/#/paths/customer-customer_uid--team_member--team_member_uid/delete](https://api.mailhardener.com/docs/#/paths/customer-customer_uid--team_member--team_member_uid/delete)

