$lines = Get-Content src/App.tsx
$targetIdx = ($lines | Select-String -Pattern "const \[selectedExchange, setSelectedExchange\]" | Select-Object -First 1).LineNumber - 1

$newLine = '  const [passphraseInput, setPassphraseInput] = useState<string>("");'

$newLines = $lines[0..$targetIdx] + $newLine + $lines[($targetIdx+1)..($lines.Length-1)]
$newLines | Set-Content src/App.tsx

Write-Host "DONE - passphrase state added"