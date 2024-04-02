<#
.SYNOPSIS
Retrieve reports from the Mailhardener API.

.DESCRIPTION
Retrieves DMARC aggregate, failure, or SMTPTLS reports for a specific domain from Mailhardener.
The API always returns reports for 7 days for DMARC aggregate or 14 days for DMARC failure and SMTP TLS
reports, regardless of the number of reports that would result in. Use the -TotalDays parameter to automatically
paginate and retrieve additional records.

Each call takes 10+ seconds to complete, so be patient when retrieving large amounts of data.

.INPUTS
None

.OUTPUTS
PSCustomObject[]
# Array of objects each representing a single report. See API documentation pages under .LINK for specific formats.

.PARAMETER CustomerId
Customer Mailhardener ID / UID

.PARAMETER DomainName
Domain name to retrieve reports for.

.PARAMETER Type
The type of report to retrieve. Valid values are 'Aggregate', 'Failure', and 'SMTPTLS'.

.PARAMETER From
The starting (most recent) date of the report data to retrieve. Must be in the format yyyy-MM-dd.
Default value is the current date.

.PARAMETER TotalDays
The total number of days of report data to retrieve. Default is the minimum for the report type.

.LINK
https://api.mailhardener.com/docs/#/paths/customer-customer_uid--domain--domain_name--dmarc_aggregate_reports/get

.LINK
https://api.mailhardener.com/docs/#/paths/customer-customer_uid--domain--domain_name--dmarc_failure_reports/get

.LINK
https://api.mailhardener.com/docs/#/paths/customer-customer_uid--domain--domain_name--smtp_tls_reports/get

.EXAMPLE
Get-EmailReport -CustomerId "1234567890" -DomainName "example.com" -Type "Aggregate"
# Returns DMARC aggregate reports for the last 7 days.

.EXAMPLE
Get-EmailReport -CustomerId "1234567890" -DomainName "example.com" -Type "Failure" -TotalDays 60
# Returns DMARC failure reports for the last 60 days.
 
.EXAMPLE
Get-EmailReport -CustomerId "12345" -DomainName "example.com" -Type "SMTPTLS" -From "2024-07-01" -TotalDays 60
# Returns SMTP TLS reports for the period May 2, 2024 - July 1, 2024.

#>
function Get-EmailReport {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Alias('customer_uid')]
        [string]$CustomerId,

        [Parameter(Mandatory)]
        [Alias('domain_name')]
        [string]$DomainName,

        [Parameter(Mandatory)]
        [ValidateSet('Aggregate', 'Failure', 'SMTPTLS')]
        [string]$Type,

        [Parameter()]
        [ValidateScript({ $_ -match '20\d\d-[0-1]\d-[0-3]\d' }, ErrorMessage = 'From must be in the format yyyy-MM-dd.')]
        [string]$From,

        [Parameter()]
        [ValidateRange(7, 366)]
        [int]$TotalDays
    )
    $minimumDaySpan = 7
    switch ($Type) {
        'Aggregate' { $reportType = 'dmarc_aggregate_reports' }
        'Failure' { 
            $reportType = 'dmarc_failure_reports'
            $minimumDaySpan = 14
        }
        'SMTPTLS' {
            $reportType = 'smtp_tls_reports'
            $minimumDaySpan = 14
        }
    }
    $uri = "https://api.mailhardener.com/v1/customer/$CustomerId/domain/$DomainName/$reportType"
    $headers = @{
        'Authorization' = "Bearer $MailhardenerAccessToken"
        'Accept'        = 'application/json'
    }
    if ($From) { $Parameters = @{ from = $From } } else { $Parameters = @{} }
    $dayCounter = 0
    do {
        Write-Debug "Retrieving report data. URI: $uri, Parameters: $($PSBoundParameters | ConvertTo-Json -Compress)"
        $call = Invoke-WebRequest -Uri $uri -Method Get -Headers $headers -Body $Parameters -SkipHttpErrorCheck
        if ($call.StatusCode -ne 200) {
            Write-Debug "Failed to retrieve data from $uri. $($call.StatusCode) $($call.StatusDescription) $($call.Content)"
        }
        $call = $call.Content | ConvertFrom-Json
        if ($call.result -eq 'success') {
            if ($call.data.Count -eq 0) {
                Write-Warning "No data found for $CustomerId $DomainName $Type $From"
                break
            }
            if ($call.data -isnot [array]) {
                $call.data
                break
            }
            $dates = $call.data.date | Select-Object -Unique | Sort-Object
            $dayCounter += $dates.count
            Write-Debug "Current call contains $($dates.count) days. New total days: $dayCounter."
            $fromDate = $dates[0]
            $toDate = $dates[-1]

            Write-Host "Retrieved $($call.data.Count) $Type reports for $DomainName, covering $($dates.count) days from $fromDate to $toDate." -ForegroundColor Yellow
            
            # Output this data
            $call.data

            # Queue up the next batch
            $Parameters.from = (Get-date -Date $fromDate).AddDays(-1).ToString('yyyy-MM-dd')
        }
        else {
            Write-Error "Failed to retrieve data from $uri. Error: $($call.message)"
            break
        }
    } while ($dates.Count -eq $minimumDaySpan -and $dayCounter -lt $TotalDays)
    Write-Host "Retrieved a total of $dayCounter days of $Type reports for $DomainName." -ForegroundColor Green
}