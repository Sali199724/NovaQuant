$lines = Get-Content server.ts
$anchorIdx = ($lines | Select-String -Pattern 'exchange: "bybit",' | Select-Object -First 1).LineNumber
$searchFrom = $anchorIdx
while ($lines[$searchFrom] -notmatch '\}, \{ merge: true \}\);') { $searchFrom++ }
$insertAfter = $searchFrom

$syncCall = @(
  '          await syncExchangeToPg(userId, userId, encryptedBinanceApiKey, encryptedBinanceApiSecret, isTestnet, "CONNECTED", true);'
)

$newLines = $lines[0..$insertAfter] + $syncCall + $lines[($insertAfter+1)..($lines.Length-1)]
$newLines | Set-Content server.ts

Write-Host "DONE - Bybit Postgres sync added"