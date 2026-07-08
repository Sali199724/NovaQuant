$lines = Get-Content src/App.tsx

# Find the unique label line for Exchange Provider
$labelIdx = ($lines | Select-String -Pattern "Exchange Provider</label>" | Select-Object -First 1).LineNumber - 1

# Find the <select line right after it
$selectStart = $labelIdx + 1
while ($lines[$selectStart] -notmatch "<select") { $selectStart++ }

# Find the matching </select> after that
$selectEnd = $selectStart
while ($lines[$selectEnd] -notmatch "</select>") { $selectEnd++ }

$replacement = @(
  '                            <select'
  "                              disabled={binanceConnectionStatus === 'CONNECTED'}"
  '                              value={selectedExchange}'
  '                              onChange={(e) => setSelectedExchange(e.target.value)}'
  '                              className="w-full bg-slate-950 border border-slate-850 text-slate-200 text-xs rounded px-2.5 py-1.5 focus:outline-none focus:border-[#fbbf24] disabled:opacity-60"'
  '                            >'
  '                              <option value="binance">Binance Futures (Unified USD-M Contract)</option>'
  '                              <option value="bybit">Bybit (USDT Perpetual)</option>'
  '                              <option value="bitget">Bitget (USDT-M Futures)</option>'
  '                            </select>'
)

$newLines = $lines[0..($selectStart-1)] + $replacement + $lines[($selectEnd+1)..($lines.Length-1)]
$newLines | Set-Content src/App.tsx

Write-Host "DONE - Exchange Provider dropdown wired (v2)"