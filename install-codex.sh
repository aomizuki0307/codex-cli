#!/bin/bash

# Codex CLI インストールスクリプト
# Docker コンテナ内で実行

echo "🚀 Codex CLI をインストール中..."

# Node.js とnpm の確認
echo "Node.js バージョン: $(node --version)"
echo "npm バージョン: $(npm --version)"

# Codex CLI のインストール
echo "📦 Codex CLI をインストール中..."
npm install -g @openai/codex

# インストール確認
if command -v codex &> /dev/null; then
    echo "✅ Codex CLI が正常にインストールされました。"
    echo "バージョン: $(codex --version)"
else
    echo "❌ Codex CLI のインストールに失敗しました。"
    exit 1
fi

echo ""
echo "🎉 セットアップが完了しました！"
echo ""
echo "次のステップ:"
echo "1. 認証を設定してください: codex auth"
echo "2. Codex を使用してください: codex"
echo ""