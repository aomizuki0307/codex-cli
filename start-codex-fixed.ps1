# PowerShell用Codex CLI起動スクリプト（ポート転送修正版）

Write-Host "🚀 Codex CLI環境を起動中（ポート転送有効）..." -ForegroundColor Green

# 既存のコンテナを停止・削除
Write-Host "🧹 既存のコンテナをクリーンアップ中..." -ForegroundColor Yellow
docker rm -f codex-cli-session 2>$null

# コンテナをポート転送付きで起動
Write-Host "📦 コンテナを起動中（ポート1455を転送）..." -ForegroundColor Yellow
$containerId = docker run -d `
    --name codex-cli-session `
    -p 1455:1455 `
    -v ${PWD}/workspace:/workspace `
    -v ${HOME}/.codex:/root/.codex `
    -w /workspace `
    --entrypoint "/bin/sleep" `
    ghcr.io/openai/codex-universal:latest `
    infinity

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ コンテナ起動成功（ポート転送: localhost:1455）" -ForegroundColor Green
    Write-Host ""

    # Node環境のセットアップとCodex CLIインストール
    Write-Host "📦 Codex CLIをインストール中..." -ForegroundColor Yellow
    docker exec codex-cli-session bash -c "source /root/.nvm/nvm.sh && nvm use 20 && npm install -g @openai/codex"

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Codex CLIインストール完了" -ForegroundColor Green
        Write-Host ""

        # 認証開始
        Write-Host "🔐 認証を開始します..." -ForegroundColor Cyan
        Write-Host "以下のコマンドを実行して認証を完了してください:" -ForegroundColor White
        Write-Host ""
        Write-Host "docker exec -it codex-cli-session bash -c 'source /root/.nvm/nvm.sh && nvm use 20 && codex login'" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "✨ 今度はブラウザでlocalhost:1455にアクセスできます！" -ForegroundColor Green
        Write-Host ""
        Write-Host "認証完了後、以下のコマンドでCodex CLIを使用できます:" -ForegroundColor White
        Write-Host "docker exec -it codex-cli-session bash -c 'source /root/.nvm/nvm.sh && nvm use 20 && codex'" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "コンテナを停止する場合:" -ForegroundColor White
        Write-Host "docker stop codex-cli-session && docker rm codex-cli-session" -ForegroundColor Yellow
    }
    else {
        Write-Host "❌ Codex CLIのインストールに失敗しました" -ForegroundColor Red
    }
}
else {
    Write-Host "❌ コンテナの起動に失敗しました" -ForegroundColor Red
}
