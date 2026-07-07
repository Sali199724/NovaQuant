$lines = Get-Content src/App.tsx

$boxStart = 3485
$boxEnd = 3487

$replacement = @(
  '                            <select'
  "                              disabled={binanceConnectionStatus === 'CONNECTED'}"
  '                              value={selectedExchange}'
  '                              onChange={(e) => setSelectedExchange(e.target.value)}'
  '                              className="w-full bg-slate-950 border border-slate-850 text-[#fbbf24] font-semibold text-xs rounded px-2.5 py-1.5 focus:outline-none focus:border-[#fbbf24] disabled:opacity-60"'
  '                            >'
  '                              <option value="binance">Binance Live (Production)</option>'
  '                              <option value="bybit">Bybit</option>'
  '                              <option value="bitget">Bitget</option>'
  '                            </select>'
)

$newLines = $lines[0..($boxStart-1)] + $replacement + $lines[($boxEnd+1)..($lines.Length-1)]
$newLines | Set-Content src/App.tsx

Write-Host "DONE - dropdown inserted"