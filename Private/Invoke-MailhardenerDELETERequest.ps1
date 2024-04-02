function Invoke-MailhardenerDELETERequest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Endpoint
    )
    try {
        if (Get-MailhardenerToken) {
            $headers = @{
                'Authorization' = "Bearer $MailhardenerAccessToken"
                'Accept'        = 'application/json'
            }

            Write-Debug "Sending DELETE request to $Endpoint."

            $response = Invoke-WebRequest -Uri "https://api.mailhardener.com/v1/$Endpoint" -Method Delete -Headers $headers -SkipHttpErrorCheck
            if ($response.StatusCode -eq 200) {
                Write-Debug "Successfully sent DELETE request to $Endpoint."
                $response.Content | ConvertFrom-Json
            }
            else {
                # Returns - 403 for an invalid or out of scope uid, 404 for a general failure, 500 for a server error
                Write-Debug "Failed to send DELETE request to $Endpoint. Response: $($response.StatusCode) - $($response.StatusDescription) $($response.Content)"
                $response.Content | ConvertFrom-Json
            }
        }
        else {
            [PSCustomObject]@{
                result  = 'failure'
                message = 'Not connected to API'
            }
        }
    }
    catch {
        Write-Error "Failed to send DELETE request to $Endpoint`: $_"
    }
}