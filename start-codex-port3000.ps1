# ポート3000での修正版Codex CLIセットアップ

Write-Host "🚀 Codex CLI環境を起動中（ポート3000使用）..." -ForegroundColor Green

# 既存のコンテナを停止・削除
Write-Host "🧹 既存のコンテナをクリーンアップ中..." -ForegroundColor Yellow
docker rm -f codex-cli-session 2>$null

# コンテナをポート3000で起動
Write-Host "📦 コンテナを起動中（ポート3000を転送）..." -ForegroundColor Yellow
$containerId = docker run -d `
    --name codex-cli-session `
    -p 3000:1455 `
    -v ${PWD}/workspace:/workspace `
    -v ${HOME}/.codex:/root/.codex `
    -w /workspace `
    --entrypoint "/bin/sleep" `
    ghcr.io/openai/codex-universal:latest `
    infinity

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ コンテナ起動成功（ポート転送: localhost:3000 -> container:1455）" -ForegroundColor Green
    Write-Host ""

    # Codex CLIインストール
    Write-Host "📦 Codex CLIをインストール中..." -ForegroundColor Yellow
    docker exec codex-cli-session bash -c "source /root/.nvm/nvm.sh && nvm use 20 && npm install -g @openai/codex"

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Codex CLIインストール完了" -ForegroundColor Green
        Write-Host ""

        Write-Host "🔐 認証手順:" -ForegroundColor Cyan
        Write-Host "1. 以下のコマンドを実行:" -ForegroundColor White
        Write-Host "   docker exec -it codex-cli-session bash -c 'source /root/.nvm/nvm.sh && nvm use 20 && CODEX_LOGIN_SERVER_HOST=0.0.0.0 codex login'" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "2. ブラウザで表示されるURLの :1455 を :3000 に変更してアクセス" -ForegroundColor White
        Write-Host "   例: http://localhost:3000/auth/callback?code=..." -ForegroundColor Green
        Write-Host ""
        Write-Host "3. または直接 http://localhost:3000 にアクセス" -ForegroundColor White
    }
}
else {
    Write-Host "❌ コンテナの起動に失敗しました" -ForegroundColor Red
}
