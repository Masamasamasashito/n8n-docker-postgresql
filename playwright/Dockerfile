# ベースはMicrosoft公式の最新タグを使用
# 注意: Microsoftは "latest" タグの挙動を保証していないため、通常は "focal" 等を使いますが
# ここでは「常に最新のOS環境」を狙うため rolling tag を使います。
FROM mcr.microsoft.com/playwright:focal

WORKDIR /app

# 最小限のpackage.jsonを生成（依存関係は起動時に決定するため空に近い状態）
RUN npm init -y

# サーバーコードをコピー
COPY server.js .

# 起動用スクリプトを作成
# 1. 環境変数で指定されたバージョンのPlaywrightをインストール
# 2. そのバージョンに対応するブラウザバイナリを強制インストール（整合性確保）
# 3. サーバー起動
RUN echo '#!/bin/bash\n\
    echo "Requested Playwright Version: $PLAYWRIGHT_TARGET_VERSION"\n\
    npm install playwright@$PLAYWRIGHT_TARGET_VERSION express\n\
    echo "Installing/Verifying matching browser binaries..."\n\
    npx playwright install --with-deps\n\
    echo "Starting Server..."\n\
    node server.js' > /app/entrypoint.sh && chmod +x /app/entrypoint.sh

# エントリーポイントを設定
ENTRYPOINT ["/app/entrypoint.sh"]