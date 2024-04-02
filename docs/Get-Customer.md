---
external help file: Mailhardener-help.xml
Module Name: Mailhardener
online version: https://api.mailhardener.com/docs/#/paths/customer/get
schema: 2.0.0
---

# Get-Customer

## SYNOPSIS
Get customer information.

## SYNTAX

```
Get-Customer [[-Id] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Returns a single customer or list of all customers (tenants) managed by this MSP.

## EXAMPLES

### EXAMPLE 1
```
Get-Customer -Id '1234567890'
Retrieves the customer with ID '1234567890'.
```

### EXAMPLE 2
```
Get-Customer
Retrieves all customers from Mailhardener.
```

## PARAMETERS

### -Id
The Mailhardener ID / UID of the customer to retrieve.
This parameter is optional.
If not provided, all customers will be retrieved.

```yaml
Type: String
Parameter Sets: (All)
Aliases: uid, customer_uid

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
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
### The customer object(s) that were retrieved.
## NOTES

## RELATED LINKS

[https://api.mailhardener.com/docs/#/paths/customer/get](https://api.mailhardener.com/docs/#/paths/customer/get)

