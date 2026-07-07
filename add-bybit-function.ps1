$lines = Get-Content server.ts
$targetIdx = ($lines | Select-String -Pattern "async function checkApiWithdrawalPermissionEnforced" | Select-Object -First 1).LineNumber - 1

$bybitFunction = @(
  ''
  '  async function testBybitConnection(apiKey: string, apiSecret: string, isTestnet: boolean) {'
  '    const baseUrl = isTestnet ? "https://api-testnet.bybit.com" : "https://api.bybit.com";'
  '    const timestamp = Date.now().toString();'
  '    const recvWindow = "10000";'
  '    const queryString = "accountType=UNIFIED";'
  '    const signPayload = timestamp + apiKey + recvWindow + queryString;'
  '    const signature = crypto.createHmac("sha256", apiSecret).update(signPayload).digest("hex");'
  ''
  '    const response = await fetch(`${baseUrl}/v5/account/wallet-balance?${queryString}`, {'
  '      method: "GET",'
  '      headers: {'
  '        "X-BAPI-API-KEY": apiKey,'
  '        "X-BAPI-TIMESTAMP": timestamp,'
  '        "X-BAPI-RECV-WINDOW": recvWindow,'
  '        "X-BAPI-SIGN": signature,'
  '      }'
  '    });'
  ''
  '    const data: any = await response.json();'
  '    if (data.retCode !== 0) {'
  '      throw new Error(data.retMsg || "Bybit connection failed.");'
  '    }'
  '    return data;'
  '  }'
  ''
)

$newLines = $lines[0..($targetIdx-1)] + $bybitFunction + $lines[$targetIdx..($lines.Length-1)]
$newLines | Set-Content server.ts

Write-Host "DONE - Bybit function added"