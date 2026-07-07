$lines = Get-Content src/App.tsx
$targetIdx = ($lines | Select-String -Pattern "isTestnet: useBinanceTestnet," | Select-Object -First 1).LineNumber - 1

$newLine = '          exchange: selectedExchange,'

$newLines = $lines[0..$targetIdx] + $newLine + $lines[($targetIdx+1)..($lines.Length-1)]
$newLines | Set-Content src/App.tsx

Write-Host "DONE - exchange field added to save call"