$url = 'https://unimpertinently-plastered-liliana.ngrok-free.dev/payment/mpesa/callback'
$headers = @{ 'ngrok-skip-browser-warning' = '1' }
$body = '{"Body":"test","TransactionType":"test"}'
try {
  $r = Invoke-WebRequest -Uri $url -Method Post -Headers $headers -Body $body -ContentType 'application/json' -TimeoutSec 30
  Write-Host "STATUS: $($r.StatusCode.Value__)"
  Write-Host "DESCRIPTION: $($r.StatusDescription)"
  Write-Host "BODY:";
  Write-Host $r.Content
} catch {
  Write-Host "ERROR: $($_.Exception.Message)"
  if ($_.Exception.Response) {
    Write-Host "STATUSCODE: $($_.Exception.Response.StatusCode.Value__)"
    Write-Host "STATUSDESC: $($_.Exception.Response.StatusDescription)"
    $stream = $_.Exception.Response.GetResponseStream()
    $sr = New-Object System.IO.StreamReader($stream)
    Write-Host "BODY:";
    Write-Host $sr.ReadToEnd()
  }
}