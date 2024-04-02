function Invoke-MailhardenerGETRequest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Endpoint,

        [Parameter()]
        [string]$Customer,

        [Parameter()]
        [string]$Limit = 50,

        [Parameter()]
        [string]$Offset = 0,

        [Parameter()]
        [switch]$All,

        [Parameter()]
        [hashtable]$Parameters = @{}
    )
    if (Get-MailhardenerToken) {
        $headers = @{
            'Authorization' = "Bearer $MailhardenerAccessToken"
            'Accept'        = 'application/json'
        }
        $Parameters.Add('_limit', $Limit)
        $Parameters.Add('_offset', $Offset)

        # Loop to get all results if paginated
        $currentResults = 0
        $totalResults = -1
        while ($currentResults -ne $totalResults) {
            $call = Invoke-RestMethod -Uri "https://api.mailhardener.com/v1/$Endpoint" -Method Get -Headers $headers -Body $Parameters
            if ($call.result -eq 'success') {
                if ($call.data -isnot [array]) {
                    $call.data
                    break
                }
                $currentResults += $call.data.Count
                $totalResults = $call.total
                Write-Verbose "Retrieved $($call.data.Count) records from /$Endpoint, of $totalResults total."
                if ($call.data.Count -ne $totalResults -and -not $All) {
                    Write-Warning "Only the first $Limit records were retrieved. Use -All to retrieve all records."
                    $call.data
                    break
                }
                $Parameters._offset = $currentResults
                $call.data
            }
            else {
                Write-Error "Failed to retrieve data from /$Endpoint. Error: $($call.message)"
                break
            }
 
        }
    }
}