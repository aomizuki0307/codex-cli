# ESET対応版：ポート8080でCodex CLI起動

Write-Host "🛡️  ESET対応版 Codex CLI環境（ポート8080使用）" -ForegroundColor Green
Write-Host ""

# 既存のコンテナを削除
docker rm -f codex-cli-session 2>$null

# ポート8080でコンテナ起動
Write-Host "📦 コンテナを起動中（ポート8080）..." -ForegroundColor Yellow
$containerId = docker run -d `
    --name codex-cli-session `
    -p 8080:1455 `
    -v ${PWD}/workspace:/workspace `
    -v ${HOME}/.codex:/root/.codex `
    -w /workspace `
    --entrypoint "/bin/sleep" `
    ghcr.io/openai/codex-universal:latest `
    infinity

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ コンテナ起動成功（ポート8080）" -ForegroundColor Green
    
    # Codex CLIインストール
    docker exec codex-cli-session bash -c "source /root/.nvm/nvm.sh && nvm use 20 && npm install -g @openai/codex"
    
    Write-Host ""
    Write-Host "🔐 認証手順（ESET対応）:" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. 以下のコマンドで認証開始:" -ForegroundColor White
    Write-Host "   docker exec -it codex-cli-session bash -c 'source /root/.nvm/nvm.sh && nvm use 20 && CODEX_LOGIN_SERVER_HOST=0.0.0.0 codex login'" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "2. 表示されるURLの :1455 を :8080 に変更してアクセス" -ForegroundColor White
    Write-Host "   例: https://auth.openai.com/oauth/authorize?...&redirect_uri=http%3A%2F%2Flocalhost%3A8080%2Fauth%2Fcallback..." -ForegroundColor Green
    Write-Host ""
    Write-Host "✨ ポート8080は一般的にファイアウォールでブロックされません" -ForegroundColor Green
}
else {
    Write-Host "❌ コンテナ起動に失敗しました" -ForegroundColor Red
}