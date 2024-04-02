---
external help file: Mailhardener-help.xml
Module Name: Mailhardener
online version: https://api.mailhardener.com/docs/#/paths/customer-customer_uid--domain/post
schema: 2.0.0
---

# New-Domain

## SYNOPSIS
Add a domain to a customer in Mailhardener.

## SYNTAX

```
New-Domain [-CustomerId] <String> [-Name] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Creates a claim on a domain for this customer.
Once DMARC or SMTP TLS reporting DNS record is detected for this customer
environment, the domain will become validated.
When adding a domain, only the name can be set.
All other properties of the domain are automatically discovered by Mailhardener.

## EXAMPLES

### EXAMPLE 1
```
New-Domain -CustomerId "1234567890" -Name "example.com"
```

### EXAMPLE 2
```
$customer = Get-Customer -Id "1234567890"
$customer | New-Domain -Name "example.com"
```

## PARAMETERS

### -CustomerId
The customer Mailhardener ID / UID.

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
The domain name to add.

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
### Customer Object
## OUTPUTS

### PSCustomObject
### Returns the newly added domain. Note that not all DNS properties of the domain may be detected at this point.
## NOTES

## RELATED LINKS

[https://api.mailhardener.com/docs/#/paths/customer-customer_uid--domain/post](https://api.mailhardener.com/docs/#/paths/customer-customer_uid--domain/post)

