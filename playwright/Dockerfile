# ベースはMicrosoft公式のPlaywrightイメージを使用
# focal: Ubuntu 20.04 LTS ベース
FROM mcr.microsoft.com/playwright:focal

WORKDIR /app

# package.jsonを初期化し、Playwrightとexpressをビルド時にインストール
# ブラウザバイナリ（Chromium, Firefox, WebKit）も同時にダウンロード
RUN npm init -y && \
    npm install playwright@latest express && \
    npx playwright install --with-deps

# サーバーコードをコピー
COPY server.js .

# シンプルなエントリーポイント - インストール不要で即起動
# 環境変数（PLAYWRIGHT_CONTAINER_LISTEN_PORT等）はdocker-compose.ymlから渡される
ENTRYPOINT ["node", "server.js"]