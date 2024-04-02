---
external help file: Mailhardener-help.xml
Module Name: Mailhardener
online version: https://api.mailhardener.com/docs/#/paths/customer-customer_uid/delete
schema: 2.0.0
---

# Remove-Domain

## SYNOPSIS
Add a domain to a customer in Mailhardener.

## SYNTAX

```
Remove-Domain [-CustomerId] <String> [-Name] <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Removes a domain from this customer.
Note: before domain is removed, all DNS entries related to Mailhardener must be removed.

## EXAMPLES

### EXAMPLE 1
```
Remove-Domain -CustomerId "1234567890" -Name "example.com"
```

### EXAMPLE 2
```
$customer = Get-Customer -Id "1234567890"
$customer | Remove-Domain -Name "example.com"
```

## PARAMETERS

### -CustomerId
The unique identifier of the customer.

```yaml
Type: String
Parameter Sets: (All)
Aliases: uid, customer_uid

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
The name of the domain to be removed.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

## NOTES

## RELATED LINKS
