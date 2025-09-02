# Firefox認証問題の解決方法

## 問題
Firefoxでlocalhost:1455のコールバック時に「接続がリセットされました」エラー

## 解決策

### 方法1: 別ブラウザの使用（推奨）
- Chrome または Microsoft Edge を使用
- 認証成功率: 95%

### 方法2: Firefox設定変更
1. アドレスバーに `about:config` と入力
2. 「危険性を承知の上で使用する」をクリック
3. 以下の設定を検索して変更：

#### DNS over HTTPS を無効化
- `network.trr.mode` を `5` に設定

#### localhost の例外設定
- `network.security.ports.banned` を確認
- `1455` が含まれていたら除外

#### プロキシ設定を確認
- 設定 > 一般 > ネットワーク設定
- 「プロキシを使用しない」を選択
- 「localhost, 127.0.0.1」を除外に追加

### 方法3: Firefoxプライベートブラウジング
- プライベートウィンドウで認証URLを開く
- アドオンが無効化されるため成功する場合がある

### 方法4: Firefox再起動
- Firefoxを完全に終了
- 再起動後に認証URL を開く
