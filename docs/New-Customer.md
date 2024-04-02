---
external help file: Mailhardener-help.xml
Module Name: Mailhardener
online version: https://api.mailhardener.com/docs/#/paths/customer/post
schema: 2.0.0
---

# New-Customer

## SYNOPSIS
Create a new customer environment

## SYNTAX

```
New-Customer [-Name] <String> [[-ExternalId] <String>] [[-Address1] <String>] [[-Address2] <String>]
 [[-City] <String>] [[-PostalCode] <String>] [[-CountryCode] <String>] [[-VatId] <String>]
 [[-InvoiceEmail] <String>] [[-InvoicePo] <String>] [[-MaxDomains] <Int32>] [[-RequireMfa] <Int32>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
This creates a new customer, which receives its own Mailhardener environment.
Each customer environment receives its own reporting endpoint (the rua value in the DMARC and SMTP TLS reporting DNS records).

## EXAMPLES

### EXAMPLE 1
```
New-Customer -Name "Example Customer" -ExternalId "12345" -Address1 "123 Main St" -City "New York" -PostalCode "10001" -CountryCode "US" -VatId "123456789" -InvoiceEmail "example@example.com" -InvoicePo "PO12345" -MaxDomains 10 -RequireMfa 2
```

### EXAMPLE 2
```
New-Customer -Name "Contoso, Inc."
# Minimum required information
```

## PARAMETERS

### -Name
The name of the customer.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExternalId
The customer (tenant) identifier assignable by the MSP.

```yaml
Type: String
Parameter Sets: (All)
Aliases: external_id

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Address1
The first line of the customer's address.

```yaml
Type: String
Parameter Sets: (All)
Aliases: address_1

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Address2
The second line of the customer's address.

```yaml
Type: String
Parameter Sets: (All)
Aliases: address_2

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -City
The city of the customer's address.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PostalCode
The postal code of the customer's address.

```yaml
Type: String
Parameter Sets: (All)
Aliases: postal_code

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CountryCode
The ISO3166-2 country code of the customer's address.

```yaml
Type: String
Parameter Sets: (All)
Aliases: country

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -VatId
The VAT-id of the customer (tenant) organization.

```yaml
Type: String
Parameter Sets: (All)
Aliases: vat_id

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InvoiceEmail
The invoice email address for the customer (not applicable for MSP tenants).

```yaml
Type: String
Parameter Sets: (All)
Aliases: invoice_email

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InvoicePo
The Purchase Order number for invoicing (not applicable for MSP tenants).

```yaml
Type: String
Parameter Sets: (All)
Aliases: invoice_po

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxDomains
The maximum number of domains the tenant is allowed to add to their account.
If not defined or 0, the maximum is defined by the
package subscription (for regular Mailhardener customers) or unlimited for MSP tenants.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: max_domains

Required: False
Position: 11
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -RequireMfa
The requirement for two-factor authentication (2FA) for the customer.
Valid values are:
- 0: REQUIRE_2FA_NEVER - Never require 2FA
- 1: REQUIRE_2FA_ACCOUNT_ADMIN - Require 2FA for account administrators
- 2: REQUIRE_2FA_DOMAIN_ADMIN - Require 2FA for domain administrators
- 3: REQUIRE_2FA_ALWAYS - Always require 2FA \[Default\]

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: require_2fa

Required: False
Position: 12
Default value: 3
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

### None
## OUTPUTS

### PSCustomObject
### The customer object that was created.
### [PSCustomObject]
### The customer object that was created.
## NOTES

## RELATED LINKS

[https://api.mailhardener.com/docs/#/paths/customer/post](https://api.mailhardener.com/docs/#/paths/customer/post)

