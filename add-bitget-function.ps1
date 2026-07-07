$lines = Get-Content server.ts
$targetIdx = ($lines | Select-String -Pattern "async function testBybitConnection" | Select-Object -First 1).LineNumber - 1

$bitgetFunction = @(
  ''
  '  async function testBitgetConnection(apiKey: string, apiSecret: string, passphrase: string, isTestnet: boolean) {'
  '    const baseUrl = "https://api.bitget.com";'
  '    const timestamp = Date.now().toString();'
  '    const method = "GET";'
  '    const requestPath = "/api/v2/mix/account/accounts?productType=USDT-FUTURES";'
  '    const prehash = timestamp + method + requestPath;'
  '    const signature = crypto.createHmac("sha256", apiSecret).update(prehash).digest("base64");'
  ''
  '    const response = await fetch(`${baseUrl}${requestPath}`, {'
  '      method: "GET",'
  '      headers: {'
  '        "ACCESS-KEY": apiKey,'
  '        "ACCESS-SIGN": signature,'
  '        "ACCESS-TIMESTAMP": timestamp,'
  '        "ACCESS-PASSPHRASE": passphrase,'
  '        "Content-Type": "application/json"'
  '      }'
  '    });'
  ''
  '    const data: any = await response.json();'
  '    if (data.code !== "00000") {'
  '      throw new Error(data.msg || "Bitget connection failed.");'
  '    }'
  '    return data;'
  '  }'
  ''
)

$newLines = $lines[0..($targetIdx-1)] + $bitgetFunction + $lines[$targetIdx..($lines.Length-1)]
$newLines | Set-Content server.ts

Write-Host "DONE - Bitget function added"