---
external help file: Mailhardener-help.xml
Module Name: Mailhardener
online version: https://api.mailhardener.com/docs/#/paths/customer/get
schema: 2.0.0
---

# Get-Domain

## SYNOPSIS
Returns the details of domain.

## SYNTAX

```
Get-Domain [-CustomerId] <String> [[-Name] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-Domain function retrieves domain information from the Mailhardener service based on the provided parameters.
It can retrieve information for a specific domain or for all domains associated with a customer.

## EXAMPLES

### EXAMPLE 1
```
Get-Domain -CustomerId "12345" -Name "example.com"
Retrieves information for the domain "example.com" associated with the customer with the ID "12345".
```

### EXAMPLE 2
```
Get-Domain -CustomerId "12345"
Retrieves information for all domains associated with the customer with the ID "12345".
```

## PARAMETERS

### -CustomerId
Specifies the unique identifier of the customer whose domain information needs to be retrieved.

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
Specifies the name of the domain for which information needs to be retrieved.
If not provided, information for all domains associated with the customer will be retrieved.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

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

### The function outputs a PSCustomObject or an array of PSCustomObjects representing the retrieved domain information.
## NOTES

## RELATED LINKS
