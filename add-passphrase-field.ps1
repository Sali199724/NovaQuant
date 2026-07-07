$lines = Get-Content src/App.tsx
$targetIdx = ($lines | Select-String -Pattern "\{/\* Mode indicator \*/\}" | Select-Object -First 1).LineNumber - 1

$passphraseBlock = @(
  '                          {selectedExchange === "bitget" && ('
  '                            <div className="space-y-1">'
  '                              <label className="sleek-label block text-[9.5px] text-slate-400 font-sans">Bitget API Passphrase</label>'
  '                              <input'
  '                                type="password"'
  '                                value={passphraseInput}'
  '                                onChange={(e) => setPassphraseInput(e.target.value)}'
  '                                disabled={binanceConnectionStatus === ''CONNECTED''}'
  '                                placeholder="Input Bitget API Passphrase..."'
  '                                className="w-full bg-slate-950 border border-slate-850 text-slate-200 text-[11px] rounded px-3 py-1.5 focus:outline-none focus:border-[#fbbf24] font-mono disabled:opacity-65"'
  '                              />'
  '                            </div>'
  '                          )}'
  ''
)

$newLines = $lines[0..($targetIdx-1)] + $passphraseBlock + $lines[$targetIdx..($lines.Length-1)]
$newLines | Set-Content src/App.tsx

Write-Host "DONE - passphrase field added"