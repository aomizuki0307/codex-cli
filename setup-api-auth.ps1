# API Key認証セットアップスクリプト

Write-Host "🔑 API Key認証セットアップ" -ForegroundColor Green
Write-Host ""
Write-Host "ブラウザ認証に問題がある場合は、API Key認証を使用できます。" -ForegroundColor Yellow
Write-Host ""

Write-Host "📋 手順:" -ForegroundColor Cyan
Write-Host "1. https://platform.openai.com/api-keys にアクセス" -ForegroundColor White
Write-Host "2. 新しいAPI キーを作成" -ForegroundColor White
Write-Host "3. 作成したAPI キーをコピー" -ForegroundColor White
Write-Host "4. 以下のコマンドで設定:" -ForegroundColor White
Write-Host ""
Write-Host "docker exec -it codex-cli-session bash -c 'source /root/.nvm/nvm.sh && nvm use 20 && echo \`"YOUR_API_KEY\`" | codex login --api-key'" -ForegroundColor Yellow
Write-Host ""
Write-Host "⚠️  注意: YOUR_API_KEYを実際のキーに置き換えてください" -ForegroundColor Red
Write-Host ""

Write-Host "💡 API Key作成後、以下のコマンドを実行してください:" -ForegroundColor Green
Write-Host ""
Write-Host '$apiKey = Read-Host "API Keyを入力してください" -AsSecureString' -ForegroundColor Yellow
Write-Host '$apiKeyPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($apiKey))' -ForegroundColor Yellow
Write-Host 'docker exec -it codex-cli-session bash -c "source /root/.nvm/nvm.sh && nvm use 20 && echo $apiKeyPlain | codex login --api-key"' -ForegroundColor Yellow