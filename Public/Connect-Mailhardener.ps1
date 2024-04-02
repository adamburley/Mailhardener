<#
.SYNOPSIS
Connect to the Mailhardener API for MSP usage

.DESCRIPTION
Accepts an Oauth2 client ID and secret and requests a session token from the Mailhardener API. On success, an access token is stored in memory for use in subsequent calls.

.PARAMETER ClientID
Client ID

.PARAMETER ClientSecret
Client secret

.LINK
https://www.mailhardener.com/dashboard/team

.LINK
https://api.mailhardener.com/docs/#/paths/session-action-access_token/post

.EXAMPLE
Connect-Mailhardener -ClientID 'your_client_id' -ClientSecret 'your_client_secret'

.NOTES
Oauth token lifetime is 30 days.

#>
function Connect-Mailhardener {
    [CmdletBinding()]
    [OutputType([System.Void])]
    param(
        [Parameter(Mandatory)]
        [Alias("client_id")]
        [string]$ClientID,

        [Parameter(Mandatory)]
        [Alias("client_secret")]
        [string]$ClientSecret
    )
    $splat = @{
        Method  = 'POST'
        Uri     = 'https://api.mailhardener.com/v1/session/action/access_token'
        Headers = @{
            'Accept'       = 'application/json'
            'Content-Type' = 'application/x-www-form-urlencoded'
        }
        Body    = @{
            'client_id'     = $ClientID
            'client_secret' = $ClientSecret
            'grant_type'    = 'client_credentials'
        }
    }
    Write-Debug "HTTP request: $($splat | ConvertTo-Json)"
    $call = Invoke-WebRequest @splat -SkipHttpErrorCheck
    Write-Debug "HTTP response: $($call | Select-Object StatusCode, StatusDescription, Content | ConvertTo-Json)"
    $response =  $call.Content | ConvertFrom-Json
    if ($response.access_token) {
        Write-Host "Successfully connected to Mailhardener." -ForegroundColor Green
        Set-Variable -Name 'MailhardenerAccessToken' -Value $response.access_token -Scope Script -Visibility Private
    }
    else {
        Write-Error "Failed to connect to Mailhardener. $($response.message)"
    }
}