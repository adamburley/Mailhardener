---
external help file: Mailhardener-help.xml
Module Name: Mailhardener
online version: https://api.mailhardener.com/docs/#/paths/customer-customer_uid--domain--domain_name--dmarc_aggregate_reports/get
schema: 2.0.0
---

# Get-EmailReport

## SYNOPSIS
Retrieve reports from the Mailhardener API.

## SYNTAX

```
Get-EmailReport [-CustomerId] <String> [-DomainName] <String> [-Type] <String> [[-From] <String>]
 [[-TotalDays] <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves DMARC aggregate, failure, or SMTPTLS reports for a specific domain from Mailhardener.
The API always returns reports for 7 days for DMARC aggregate or 14 days for DMARC failure and SMTP TLS
reports, regardless of the number of reports that would result in.
Use the -TotalDays parameter to automatically
paginate and retrieve additional records.

Each call takes 10+ seconds to complete, so be patient when retrieving large amounts of data.

## EXAMPLES

### EXAMPLE 1
```
Get-EmailReport -CustomerId "1234567890" -DomainName "example.com" -Type "Aggregate"
# Returns DMARC aggregate reports for the last 7 days.
```

### EXAMPLE 2
```
Get-EmailReport -CustomerId "1234567890" -DomainName "example.com" -Type "Failure" -TotalDays 60
# Returns DMARC failure reports for the last 60 days.
```

### EXAMPLE 3
```
Get-EmailReport -CustomerId "12345" -DomainName "example.com" -Type "SMTPTLS" -From "2024-07-01" -TotalDays 60
# Returns SMTP TLS reports for the period May 2, 2024 - July 1, 2024.
```

## PARAMETERS

### -CustomerId
Customer Mailhardener ID / UID

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

### -DomainName
Domain name to retrieve reports for.

```yaml
Type: String
Parameter Sets: (All)
Aliases: domain_name

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The type of report to retrieve.
Valid values are 'Aggregate', 'Failure', and 'SMTPTLS'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -From
The starting (most recent) date of the report data to retrieve.
Must be in the format yyyy-MM-dd.
Default value is the current date.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TotalDays
The total number of days of report data to retrieve.
Default is the minimum for the report type.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
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

### PSCustomObject[]
### # Array of objects each representing a single report. See API documentation pages under .LINK for specific formats.
## NOTES

## RELATED LINKS

[https://api.mailhardener.com/docs/#/paths/customer-customer_uid--domain--domain_name--dmarc_aggregate_reports/get](https://api.mailhardener.com/docs/#/paths/customer-customer_uid--domain--domain_name--dmarc_aggregate_reports/get)

[https://api.mailhardener.com/docs/#/paths/customer-customer_uid--domain--domain_name--dmarc_failure_reports/get](https://api.mailhardener.com/docs/#/paths/customer-customer_uid--domain--domain_name--dmarc_failure_reports/get)

[https://api.mailhardener.com/docs/#/paths/customer-customer_uid--domain--domain_name--smtp_tls_reports/get](https://api.mailhardener.com/docs/#/paths/customer-customer_uid--domain--domain_name--smtp_tls_reports/get)

