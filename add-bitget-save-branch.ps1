$lines = Get-Content server.ts
$targetIdx = ($lines | Select-String -Pattern "const handleSaveUserBinanceCredentials = async" | Select-Object -First 1).LineNumber

$branch = @(
  '    const exchangeType2 = (req.body.exchange || "binance").toLowerCase();'
  '    if (exchangeType2 === "bitget") {'
  '      try {'
  '        const userId = await getUserIdFromRequest(req);'
  '        if (!userId) {'
  '          return res.status(401).json({ success: false, error: "Unauthorized. Session signature missing." });'
  '        }'
  '        const apiKey = req.body.apiKey?.trim();'
  '        const apiSecret = req.body.apiSecret?.trim();'
  '        const passphrase = req.body.passphrase?.trim();'
  '        const isTestnet = req.body.isTestnet !== false;'
  '        if (!apiKey || !apiSecret || !passphrase) {'
  '          return res.status(400).json({ success: false, error: "Missing required credential parameters: apiKey, apiSecret, or passphrase." });'
  '        }'
  '        await testBitgetConnection(apiKey, apiSecret, passphrase, isTestnet);'
  '        const encryptedBinanceApiKey = encryptSecret(apiKey);'
  '        const encryptedBinanceApiSecret = encryptSecret(apiSecret);'
  '        const encryptedPassphrase = encryptSecret(passphrase);'
  '        const db = getAdminDb();'
  '        if (db) {'
  '          await db.collection("users").doc(userId).set({'
  '            encryptedBinanceApiKey,'
  '            encryptedBinanceApiSecret,'
  '            encryptedPassphrase,'
  '            exchange: "bitget",'
  '            isTestnet,'
  '            tradingEnabled: true,'
  '            updatedAt: new Date().toISOString()'
  '          }, { merge: true });'
  '        }'
  '        return res.json({ success: true, message: "Bitget credentials saved and verified successfully." });'
  '      } catch (bitgetErr: any) {'
  '        return res.status(400).json({ success: false, error: bitgetErr.message || "Bitget connection failed." });'
  '      }'
  '    }'
  ''
)

$newLines = $lines[0..($targetIdx-1)] + $branch + $lines[$targetIdx..($lines.Length-1)]
$newLines | Set-Content server.ts

Write-Host "DONE - Bitget save branch added"