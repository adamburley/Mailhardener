---
external help file: Mailhardener-help.xml
Module Name: Mailhardener
online version: https://api.mailhardener.com/docs/#/paths/customer-customer_uid/delete
schema: 2.0.0
---

# Remove-Customer

## SYNOPSIS
Delete a customer environment.

## SYNTAX

```
Remove-Customer [-Id] <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This will remove a customer, and its environment.
A customer can only be deleted if all domains are removed from
the customer (tenant) environment.

## EXAMPLES

### EXAMPLE 1
```
Remove-Customer -Id "1234567890"
```

### EXAMPLE 2
```
$customer | Remove-Customer
```

### EXAMPLE 3
```
Remove-Customer -Id "1234567890" -Confirm:$false
# Remove a customer without prompting.
```

## PARAMETERS

### -Id
The Mailhardener ID / UID of the customer to remove.

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
### Customer object returned from Get-Customer.
## OUTPUTS

### None
## NOTES

## RELATED LINKS

[https://api.mailhardener.com/docs/#/paths/customer-customer_uid/delete](https://api.mailhardener.com/docs/#/paths/customer-customer_uid/delete)

