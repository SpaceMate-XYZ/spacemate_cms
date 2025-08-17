<#
PowerShell script to call menu grids API for integration testing.
Usage:
  pwsh .\test_menu_for_user.ps1 -PlaceId <placeId> -Token <BearerToken>
Example:
  pwsh .\test_menu_for_user.ps1 -PlaceId cmdirt76g0000fhodxv1hfi6e -Token '<long-jwt-token-here>'
#>
param(
    [Parameter(Mandatory=$true)]
    [string]$PlaceId,

    [Parameter(Mandatory=$true)]
    [string]$Token
)

$uri = "https://nowwococg4wcw884g4cskck0.server.spacemate.xyz/api/v1/menu/grids/for-user?placeId=$PlaceId"

try {
    Write-Host "Requesting: $uri" -ForegroundColor Cyan
    $headers = @{ Authorization = "Bearer $Token" }
    $response = Invoke-RestMethod -Uri $uri -Headers $headers -Method Get -ErrorAction Stop
    Write-Host "--- Response (parsed JSON) ---" -ForegroundColor Green
    $response | ConvertTo-Json -Depth 10
}
catch {
    Write-Host "Request failed:" -ForegroundColor Red
    Write-Host $_.Exception.Message
    if ($_.Exception.Response) {
        $stream = $_.Exception.Response.GetResponseStream()
        $reader = New-Object System.IO.StreamReader($stream)
        $body = $reader.ReadToEnd()
        Write-Host "Response body:" -ForegroundColor Yellow
        Write-Host $body
    }
    exit 1
}

exit 0
