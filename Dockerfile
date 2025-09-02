# OpenAI Codex CLI Docker Environment
FROM node:20-bookworm

# タイムゾーンの設定
ARG TZ=Asia/Tokyo
ENV TZ=${TZ}

# 必要なパッケージのインストール（公式Dockerfileに基づく）
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    wget \
    zsh \
    vim \
    nano \
    jq \
    ripgrep \
    iproute2 \
    iptables \
    ca-certificates \
    tzdata \
    build-essential \
    python3 \
    python3-pip \
    python3-venv \
    openssh-client \
 && rm -rf /var/lib/apt/lists/*

# タイムゾーン設定
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# グローバルnpmパッケージ用ディレクトリの設定
ENV NPM_CONFIG_PREFIX=/usr/local/share/npm-global
ENV PATH=$PATH:/usr/local/share/npm-global/bin

# OpenAI Codex CLIのインストール
RUN npm install -g @openai/codex && \
    npm cache clean --force

# 非rootユーザー作成
RUN useradd -m -s /bin/zsh coder && \
    mkdir -p /home/coder/.codex && \
    chown -R coder:coder /home/coder

# 作業ディレクトリの設定
WORKDIR /workspace
RUN chown -R coder:coder /workspace

# coderユーザーに切り替え
USER coder

# 環境変数の設定
ENV CODEX_DATA_DIR=/home/coder/.codex
ENV CODEX_UNSAFE_ALLOW_NO_SANDBOX=1

# ポートの公開（認証用）
EXPOSE 1455

# デフォルトコマンド
ENTRYPOINT ["codex"]
