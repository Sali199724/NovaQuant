$lines = Get-Content server.ts
$targetIdx = ($lines | Select-String -Pattern "const handleTestUserBinanceConnection = async" | Select-Object -First 1).LineNumber

$branch = @(
  '    const exchange = (req.body.exchange || req.query.exchange || "binance").toString().toLowerCase();'
  '    if (exchange === "bybit") {'
  '      try {'
  '        let apiKey = req.body.apiKey;'
  '        let apiSecret = req.body.apiSecret;'
  '        const isTestnet = req.body.isTestnet !== false;'
  '        if (!apiKey || !apiSecret) {'
  '          const userId = await getUserIdFromRequest(req);'
  '          if (!userId) {'
  '            return res.status(401).json({ success: false, error: "Unauthorized. No credentials provided to test." });'
  '          }'
  '          const creds = await getUserBinanceCredentials(userId);'
  '          if (!creds) {'
  '            return res.status(400).json({ success: false, error: "No saved credentials found to test. Please save them first." });'
  '          }'
  '          apiKey = creds.apiKey;'
  '          apiSecret = creds.apiSecret;'
  '        }'
  '        const data = await testBybitConnection(apiKey, apiSecret, isTestnet);'
  '        return res.json({ success: true, connected: true, exchange: "bybit", data });'
  '      } catch (bybitErr: any) {'
  '        return res.status(400).json({ success: false, connected: false, error: bybitErr.message || "Bybit connection failed." });'
  '      }'
  '    }'
  ''
)

$newLines = $lines[0..($targetIdx-1)] + $branch + $lines[$targetIdx..($lines.Length-1)]
$newLines | Set-Content server.ts

Write-Host "DONE - Bybit test branch added"