$old = '                            <select
                              disabled={binanceConnectionStatus === ''CONNECTED''}
                              value={selectedExchange}
                              onChange={(e) => setSelectedExchange(e.target.value)}
                              className="w-full bg-slate-950 border border-slate-850 text-[#fbbf24] font-semibold text-xs rounded px-2.5 py-1.5 focus:outline-none focus:border-[#fbbf24] disabled:opacity-60"
                            >
                              <option value="binance">Binance Live (Production)</option>
                              <option value="bybit">Bybit</option>
                              <option value="bitget">Bitget</option>
                            </select>'

$new = '                            <select
                              disabled={binanceConnectionStatus === ''CONNECTED''}
                              value={useBinanceTestnet ? "testnet" : "live"}
                              onChange={(e) => setUseBinanceTestnet(e.target.value === "testnet")}
                              className="w-full bg-slate-950 border border-slate-850 text-[#fbbf24] font-semibold text-xs rounded px-2.5 py-1.5 focus:outline-none focus:border-[#fbbf24] disabled:opacity-60"
                            >
                              <option value="live">Live (Production)</option>
                              <option value="testnet">Testnet (Sandbox)</option>
                            </select>'

(Get-Content src/App.tsx -Raw) -replace [regex]::Escape($old), $new | Set-Content src/App.tsx -NoNewline

Write-Host "DONE - Environment Mode reverted to Live/Testnet toggle"