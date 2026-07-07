$lines = Get-Content server.ts
$targetIdx = ($lines | Select-String -Pattern "const handleSaveUserBinanceCredentials = async" | Select-Object -First 1).LineNumber

$branch = @(
  '    const exchange = (req.body.exchange || "binance").toLowerCase();'
  '    if (exchange === "bybit") {'
  '      try {'
  '        const userId = await getUserIdFromRequest(req);'
  '        if (!userId) {'
  '          return res.status(401).json({ success: false, error: "Unauthorized. Session signature missing." });'
  '        }'
  '        const apiKey = req.body.apiKey?.trim();'
  '        const apiSecret = req.body.apiSecret?.trim();'
  '        const isTestnet = req.body.isTestnet !== false;'
  '        if (!apiKey || !apiSecret) {'
  '          return res.status(400).json({ success: false, error: "Missing required credential parameters: apiKey and apiSecret." });'
  '        }'
  '        await testBybitConnection(apiKey, apiSecret, isTestnet);'
  '        const encryptedBinanceApiKey = encryptSecret(apiKey);'
  '        const encryptedBinanceApiSecret = encryptSecret(apiSecret);'
  '        const db = getAdminDb();'
  '        if (db) {'
  '          await db.collection("users").doc(userId).set({'
  '            encryptedBinanceApiKey,'
  '            encryptedBinanceApiSecret,'
  '            exchange: "bybit",'
  '            isTestnet,'
  '            tradingEnabled: true,'
  '            updatedAt: new Date().toISOString()'
  '          }, { merge: true });'
  '        }'
  '        return res.json({ success: true, message: "Bybit credentials saved and verified successfully." });'
  '      } catch (bybitErr: any) {'
  '        return res.status(400).json({ success: false, error: bybitErr.message || "Bybit connection failed." });'
  '      }'
  '    }'
  ''
)

$newLines = $lines[0..($targetIdx-1)] + $branch + $lines[$targetIdx..($lines.Length-1)]
$newLines | Set-Content server.ts

Write-Host "DONE - Bybit save branch added"