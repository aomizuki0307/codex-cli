#!/bin/bash

# Docker環境テストスクリプト

echo "🧪 OpenAI Codex CLI Docker環境のテストを開始..."

echo ""
echo "1. 🐳 Docker環境の確認"
docker --version || { echo "❌ Dockerが利用できません"; exit 1; }
docker-compose --version || { echo "❌ Docker Composeが利用できません"; exit 1; }

echo ""
echo "2. 📦 codex-universal イメージの確認"
docker images | grep codex-universal && echo "✅ codex-universalイメージが存在します" || echo "⚠️  codex-universalイメージが見つかりません"

echo ""
echo "3. 🏃 codex-universal コンテナでのテスト"
echo "Node.js環境のテスト中..."
docker-compose run --rm codex-universal node --version && echo "✅ Node.js が動作しています"

echo ""
echo "Python環境のテスト中..."
docker-compose run --rm codex-universal python3 --version && echo "✅ Python が動作しています"

echo ""
echo "4. 📄 ファイル構成の確認"
if [[ -f "docker-compose.yml" ]]; then
    echo "✅ docker-compose.yml が存在します"
else
    echo "❌ docker-compose.yml が見つかりません"
    exit 1
fi

if [[ -f "README.md" ]]; then
    echo "✅ README.md が存在します"
else
    echo "⚠️  README.md が見つかりません"
fi

if [[ -d "workspace" ]]; then
    echo "✅ workspace フォルダが存在します"
else
    echo "⚠️  workspace フォルダが見つかりません"
fi

if [[ -d "scripts" ]]; then
    echo "✅ scripts フォルダが存在します"
else
    echo "⚠️  scripts フォルダが見つかりません"
fi

echo ""
echo "5. 🔧 Codex CLI のインストール確認"
echo "コンテナ内でCodex CLIをインストール中..."
docker-compose run --rm codex-universal bash -c "
    echo '📦 Codex CLIをインストール中...'
    npm install -g @openai/codex 2>/dev/null
    if command -v codex &> /dev/null; then
        echo '✅ Codex CLI がインストールされました'
        codex --version 2>/dev/null || echo 'バージョン情報取得中...'
        echo '✅ 基本テストが完了しました'
    else
        echo '❌ Codex CLI のインストールに失敗しました'
        exit 1
    fi
"

echo ""
echo "🎉 環境テストが完了しました！"
echo ""
echo "📝 使用方法:"
echo "1. codex-universal環境を起動: docker-compose run --rm codex-universal"
echo "2. コンテナ内でCodexをインストール: npm install -g @openai/codex"
echo "3. 認証を設定: codex auth"
echo "4. Codexを使用: codex"
echo ""
echo "詳細は README.md をご覧ください。"