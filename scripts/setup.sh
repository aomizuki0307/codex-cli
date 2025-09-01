#!/bin/bash

# OpenAI Codex CLI Docker環境セットアップスクリプト
# Usage: ./scripts/setup.sh

set -e

echo "🚀 OpenAI Codex CLI Docker環境のセットアップを開始します..."

# 前提条件チェック
echo "📋 前提条件をチェック中..."

# Dockerの確認
if ! command -v docker &> /dev/null; then
    echo "❌ Dockerがインストールされていません。Docker Desktopをインストールしてください。"
    echo "   https://www.docker.com/products/docker-desktop/"
    exit 1
fi

# Docker Composeの確認
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Composeが利用できません。Docker Desktopを最新版に更新してください。"
    exit 1
fi

echo "✅ Docker環境を確認しました。"

# Docker Composeファイルの存在確認
if [[ ! -f "docker-compose.yml" ]]; then
    echo "❌ docker-compose.ymlが見つかりません。正しいディレクトリで実行してください。"
    exit 1
fi

echo "✅ 設定ファイルを確認しました。"

# 環境の選択
echo ""
echo "🔧 セットアップする環境を選択してください:"
echo "1) codex-cli (カスタム環境 - 推奨)"
echo "2) codex-universal (公式マルチ言語環境)"
echo "3) 両方"

read -p "選択 (1-3): " choice

case $choice in
    1)
        SERVICES="codex-cli"
        echo "📦 カスタムCodex CLI環境をセットアップします..."
        ;;
    2)
        SERVICES="codex-universal"
        echo "📦 公式Codex Universal環境をセットアップします..."
        ;;
    3)
        SERVICES="codex-cli codex-universal"
        echo "📦 両方の環境をセットアップします..."
        ;;
    *)
        echo "❌ 無効な選択です。"
        exit 1
        ;;
esac

# Dockerイメージのビルド/プル
echo ""
echo "🏗️  Dockerイメージを準備中..."

for service in $SERVICES; do
    if [[ $service == "codex-cli" ]]; then
        echo "カスタムイメージをビルド中..."
        docker-compose build codex-cli
    elif [[ $service == "codex-universal" ]]; then
        echo "公式イメージをプル中..."
        docker-compose pull codex-universal
    fi
done

# ワークスペースの準備
echo ""
echo "📁 ワークスペースを準備中..."

# workspaceディレクトリの作成と権限設定
mkdir -p workspace
chmod 755 workspace

# サンプルファイルの作成
cat > workspace/hello.py << EOF
# サンプルPythonファイル
def greet(name):
    """挨拶を出力する関数"""
    return f"Hello, {name}!"

if __name__ == "__main__":
    print(greet("World"))
EOF

cat > workspace/hello.js << EOF
// サンプルJavaScriptファイル
function greet(name) {
    return \`Hello, \${name}!\`;
}

console.log(greet('World'));
EOF

echo "✅ サンプルファイルを作成しました。"

# 設定フォルダの準備
echo ""
echo "⚙️  設定フォルダを準備中..."

# .codexフォルダが存在しない場合は作成
if [[ ! -d "$HOME/.codex" ]]; then
    mkdir -p "$HOME/.codex"
    echo "✅ ~/.codex フォルダを作成しました。"
else
    echo "✅ ~/.codex フォルダが既に存在します。"
fi

# 環境の動作テスト
echo ""
echo "🧪 環境をテスト中..."

for service in $SERVICES; do
    echo "Testing $service..."
    if docker-compose run --rm $service --version; then
        echo "✅ $service は正常に動作します。"
    else
        echo "⚠️  $service のテストに失敗しました。手動で確認してください。"
    fi
done

# セットアップ完了
echo ""
echo "🎉 セットアップが完了しました！"
echo ""
echo "📝 次のステップ:"
echo "1. 認証を設定してください:"

for service in $SERVICES; do
    echo "   docker-compose run --rm $service auth"
done

echo ""
echo "2. Codex CLIを使い始めてください:"
for service in $SERVICES; do
    echo "   docker-compose run --rm $service"
done

echo ""
echo "3. ヘルプを確認してください:"
echo "   docker-compose run --rm codex-cli --help"

echo ""
echo "📖 詳細については README.md をご覧ください。"
echo ""
echo "Happy Coding! 🚀"