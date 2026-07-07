$lines = Get-Content server.ts
$anchorIdx = ($lines | Select-String -Pattern 'encryptedPassphrase,' | Select-Object -First 1).LineNumber
# find the closing merge line after this anchor
$searchFrom = $anchorIdx
while ($lines[$searchFrom] -notmatch '\}, \{ merge: true \}\);') { $searchFrom++ }
$insertAfter = $searchFrom  # 0-indexed position of the merge-close line

$syncCall = @(
  '          await syncExchangeToPg(userId, userId, encryptedBinanceApiKey, encryptedBinanceApiSecret, isTestnet, "CONNECTED", true);'
)

$newLines = $lines[0..$insertAfter] + $syncCall + $lines[($insertAfter+1)..($lines.Length-1)]
$newLines | Set-Content server.ts

Write-Host "DONE - Bitget Postgres sync added"