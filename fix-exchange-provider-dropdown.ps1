$old = '                            <select
                              disabled={binanceConnectionStatus === ''CONNECTED''}
                              className="w-full bg-slate-950 border border-slate-850 text-slate-200 text-xs rounded px-2.5 py-1.5 focus:outline-none focus:border-[#fbbf24] disabled:opacity-60"
                            >
                              <option value="binance_futures">Binance Futures (Unified USD-M Contract)</option>
                            </select>'

$new = '                            <select
                              disabled={binanceConnectionStatus === ''CONNECTED''}
                              value={selectedExchange}
                              onChange={(e) => setSelectedExchange(e.target.value)}
                              className="w-full bg-slate-950 border border-slate-850 text-slate-200 text-xs rounded px-2.5 py-1.5 focus:outline-none focus:border-[#fbbf24] disabled:opacity-60"
                            >
                              <option value="binance">Binance Futures (Unified USD-M Contract)</option>
                              <option value="bybit">Bybit (USDT Perpetual)</option>
                              <option value="bitget">Bitget (USDT-M Futures)</option>
                            </select>'

(Get-Content src/App.tsx -Raw) -replace [regex]::Escape($old), $new | Set-Content src/App.tsx -NoNewline

Write-Host "DONE - Exchange Provider dropdown wired"