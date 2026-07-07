$lines = Get-Content src/db/schema.ts
$targetIdx = ($lines | Select-String -Pattern 'secretKey: text\("secret_key"\).notNull\(\)' | Select-Object -First 1).LineNumber

$newLine = '  passphrase: text("passphrase"), // encrypted, only used by Bitget'

$newLines = $lines[0..($targetIdx-1)] + $newLine + $lines[$targetIdx..($lines.Length-1)]
$newLines | Set-Content src/db/schema.ts

Write-Host "DONE - passphrase column added to schema"