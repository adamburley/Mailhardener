function Invoke-MailhardenerPOSTRequest {
    param (
        [Parameter(Mandatory)]
        [string]$Endpoint,

        [Parameter(Mandatory)]
        [hashtable]$Body
    )
    if (Get-MailhardenerToken) {
        $headers = @{
            'Authorization' = "Bearer $MailhardenerAccessToken"
            'Content-Type'  = 'application/json'
            'Accept'        = 'application/json'
        }
        try {
            $response = Invoke-RestMethod -Uri "https://api.mailhardener.com/v1/$Endpoint" -Method Post -Body ($Body | ConvertTo-Json -Compress) -Headers $headers
            return $response
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
    else {
        return [PSCustomObject]@{
            result  = 'error'
            message = 'Not connected to API'
        }
    }
}