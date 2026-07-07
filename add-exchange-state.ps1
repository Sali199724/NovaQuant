$lines = Get-Content src/App.tsx
$targetIdx = ($lines | Select-String -Pattern "useBinanceTestnet, setUseBinanceTestnet" | Select-Object -First 1).LineNumber - 1

$newLine = '  const [selectedExchange, setSelectedExchange] = useState<string>("binance");'

$newLines = $lines[0..$targetIdx] + $newLine + $lines[($targetIdx+1)..($lines.Length-1)]
$newLines | Set-Content src/App.tsx

Write-Host "DONE - state variable added"