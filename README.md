# OpenAI Codex CLI Docker Environment

Docker を使用した OpenAI Codex CLI の開発環境です。

## 前提条件

- Docker Desktop がインストール済み
- OpenAI アカウント（ChatGPT Plus/Pro/Team/Enterprise推奨）
- Git がインストール済み

## セットアップ

### 1. このリポジトリのクローンまたはダウンロード
```bash
cd C:\Users\wandt\Codex_CLI
```

### 2. Docker環境の構築
```bash
# カスタムDockerfileを使用してビルド
docker-compose build codex-cli

# または公式のcodex-universalイメージを使用
docker-compose pull codex-universal
```

### 3. コンテナの起動
```bash
# カスタム環境を起動
docker-compose run --rm codex-cli

# または公式環境を起動
docker-compose run --rm codex-universal
```

### 4. 認証設定（初回のみ）
```bash
# コンテナ内で認証を開始
codex auth

# ブラウザでlocalhost:1455を開いてログイン
# 認証完了後、設定ファイルがホストの~/.codexに保存されます
```

## 使用方法

### 基本的なCodexコマンド
```bash
# ヘルプの表示
codex --help

# 対話モードの開始
codex

# ファイルを指定してCodexに質問
codex "このPythonコードを最適化して" example.py

# スクリーンショットを含む質問
codex "このUIを改善して" screenshot.png
```

### Docker Composeサービス

#### codex-cli（カスタム環境）
- Node.js 24ベース
- 開発ツール（git, vim, jq, ripgrepなど）完備
- 日本時間設定
- ポート1455でアクセス可能

#### codex-universal（公式環境）
- OpenAI公式のマルチ言語環境
- Python 3.12, Node.js 20を含む複数言語サポート
- ポート1456でアクセス可能

## ファイル構成

```
C:\Users\wandt\Codex_CLI\
├── docker-compose.yml    # Docker Compose設定
├── Dockerfile           # カスタムコンテナ定義
├── README.md           # このファイル
├── scripts/            # セットアップスクリプト
│   ├── setup.sh        # 初期セットアップ
│   └── auth.sh         # 認証ヘルパー
└── workspace/          # 作業フォルダ（コンテナとマウント）
```

## 設定

### 環境変数
- `TZ`: タイムゾーン（デフォルト: Asia/Tokyo）
- `CODEX_ENV_PYTHON_VERSION`: Pythonバージョン（universalのみ）
- `CODEX_ENV_NODE_VERSION`: Node.jsバージョン（universalのみ）
- `CODEX_UNSAFE_ALLOW_NO_SANDBOX`: サンドボックス無効化

### 設定ファイル
設定は `~/.codex/config.toml` に保存されます：
```toml
[auth]
method = "chatgpt_account"

[model]
default = "o1-preview"

[ui]
show_line_numbers = true
syntax_highlighting = true
```

## トラブルシューティング

### 認証エラー
```bash
# 認証情報をリセット
rm -rf ~/.codex/auth.json
codex auth
```

### Dockerの権限エラー
```bash
# Docker Desktopを管理者権限で実行
# または、WSL2モードに変更
```

### ネットワークエラー
```bash
# ポート1455が使用中の場合
docker-compose down
netstat -ano | findstr :1455
```

## 高度な使用法

### カスタムモデル設定
```bash
# 設定ファイルでモデルを変更
codex config set model.default o1-mini
```

### MCP（Model Context Protocol）の使用
```bash
# MCPサーバーとの連携
codex config set mcp.enabled true
```

### バッチ処理
```bash
# 複数ファイルの一括処理
find ./workspace -name "*.py" -exec codex "コメントを追加" {} \;
```

## ライセンス

このDocker設定はApache-2.0ライセンスです。OpenAI Codex CLIは独自のライセンスに従います。