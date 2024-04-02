---
external help file: Mailhardener-help.xml
Module Name: Mailhardener
online version: https://api.mailhardener.com/docs/#/paths/customer/post
schema: 2.0.0
---

# Show-ReportingEndpoint

## SYNOPSIS
Displays the reporting endpoint for a given customer by calculating the Mailhardener ID in hex.
Accepts a customer ID as input or a piped customer object.

## SYNTAX

```
Show-ReportingEndpoint [-Id] <Int32> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### EXAMPLE 1
```
Show-ReportingEndpoint -Id 1234567890
499602d2@in.mailhardener.com
```

### EXAMPLE 2
```
$customer = Get-Customer -Id 1234567890
$customer | Show-ReportingEndpoint
499602d2@in.mailhardener.com
```

## PARAMETERS

### -Id
The Mailhardener customer ID / UID.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: uid

Required: True
Position: 1
Default value: 0
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

### PSCustomObject
### Mailhardener customer object returned from API
## OUTPUTS

### String
## NOTES

## RELATED LINKS

[https://api.mailhardener.com/docs/#/paths/customer/post](https://api.mailhardener.com/docs/#/paths/customer/post)

