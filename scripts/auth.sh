#!/bin/bash

# OpenAI Codex CLI 認証ヘルパースクリプト
# Usage: ./scripts/auth.sh

set -e

echo "🔐 OpenAI Codex CLI 認証設定を開始します..."

# 環境の選択
echo ""
echo "🔧 認証を設定する環境を選択してください:"
echo "1) codex-cli (カスタム環境)"
echo "2) codex-universal (公式環境)"

read -p "選択 (1-2): " choice

case $choice in
    1)
        SERVICE="codex-cli"
        PORT="1455"
        echo "📦 カスタムCodex CLI環境の認証を設定します..."
        ;;
    2)
        SERVICE="codex-universal"
        PORT="1456"
        echo "📦 公式Codex Universal環境の認証を設定します..."
        ;;
    *)
        echo "❌ 無効な選択です。"
        exit 1
        ;;
esac

# 既存の認証確認
if [[ -f "$HOME/.codex/auth.json" ]]; then
    echo ""
    echo "⚠️  既存の認証情報が見つかりました:"
    echo "   $HOME/.codex/auth.json"
    echo ""
    read -p "既存の認証情報をリセットしますか？ (y/N): " reset_auth
    
    if [[ $reset_auth =~ ^[Yy]$ ]]; then
        rm -f "$HOME/.codex/auth.json"
        echo "✅ 既存の認証情報をリセットしました。"
    else
        echo "ℹ️  既存の認証情報を維持します。"
    fi
fi

echo ""
echo "🚀 認証プロセスを開始します..."
echo ""
echo "📝 手順:"
echo "1. コンテナ内で 'codex auth' コマンドを実行します"
echo "2. ブラウザで http://localhost:$PORT を開きます"
echo "3. OpenAI アカウントでログインします"
echo "4. 認証が完了するまで待ちます"
echo ""

read -p "続行しますか？ (y/N): " continue_auth

if [[ ! $continue_auth =~ ^[Yy]$ ]]; then
    echo "❌ 認証設定をキャンセルしました。"
    exit 1
fi

# 認証用コンテナの起動
echo ""
echo "🏃 認証用コンテナを起動中..."

# バックグラウンドで認証サーバーを起動
echo "Starting authentication server..."
docker-compose run --rm -d --name codex-auth-$SERVICE -p $PORT:1455 $SERVICE auth &

# 少し待機
sleep 3

echo ""
echo "🌐 ブラウザを開いて認証を完了してください:"
echo "   URL: http://localhost:$PORT"
echo ""
echo "認証が完了したら、このスクリプトは自動的に終了します。"

# 認証完了の監視
AUTH_SUCCESS=false
TIMEOUT=300  # 5分のタイムアウト
START_TIME=$(date +%s)

while [[ $AUTH_SUCCESS == false ]]; do
    # タイムアウトチェック
    CURRENT_TIME=$(date +%s)
    ELAPSED=$((CURRENT_TIME - START_TIME))
    
    if [[ $ELAPSED -gt $TIMEOUT ]]; then
        echo ""
        echo "⏰ タイムアウトしました（${TIMEOUT}秒）。認証を手動で確認してください。"
        break
    fi
    
    # 認証ファイルの存在確認
    if [[ -f "$HOME/.codex/auth.json" ]]; then
        echo ""
        echo "✅ 認証が完了しました！"
        AUTH_SUCCESS=true
        break
    fi
    
    echo -n "."
    sleep 5
done

# コンテナのクリーンアップ
echo ""
echo "🧹 コンテナをクリーンアップ中..."
docker stop codex-auth-$SERVICE 2>/dev/null || true
docker rm codex-auth-$SERVICE 2>/dev/null || true

if [[ $AUTH_SUCCESS == true ]]; then
    echo ""
    echo "🎉 認証設定が完了しました！"
    echo ""
    echo "📝 次のステップ:"
    echo "1. Codex CLIを使用してください:"
    echo "   docker-compose run --rm $SERVICE"
    echo ""
    echo "2. 設定を確認してください:"
    echo "   cat ~/.codex/config.toml"
    echo ""
    echo "3. テストしてください:"
    echo "   docker-compose run --rm $SERVICE --help"
    echo ""
else
    echo ""
    echo "⚠️  認証が完了していない可能性があります。"
    echo "手動で認証を確認してください:"
    echo "   docker-compose run --rm $SERVICE auth"
    echo ""
fi

echo "Happy Coding! 🚀"