# EC Portfolio Store

Rails 8で構築されたポートフォリオ用ECシステムです。

## 技術スタック

- **Ruby on Rails 8.0.2**
- **PostgreSQL 15**
- **Bootstrap 5**
- **Docker & Docker Compose**
- **Redis**
- **Devise** (認証)
- **Kaminari** (ページネーション)
- **ridgepole** (スキーマ管理)

## 機能

- ユーザー認証・登録
- 商品管理（CRUD）
- カテゴリ管理
- ショッピングカート
- 注文管理
- 在庫管理
- 検索・フィルタリング
- レスポンシブデザイン

## セットアップ

### Docker Composeを使用（推奨）

1. リポジトリをクローン
```bash
git clone <repository-url>
cd ec_fullscratch_on_rails_portfolio
```

2. 初回セットアップを実行
```bash
make setup
# または
./bin/docker-setup
```

3. アプリケーションにアクセス
- アプリケーション: http://localhost:3000
- データベース: localhost:5432
- Redis: localhost:6379

### プロジェクト構造

```
ec_fullscratch_on_rails_portfolio/
├── docker/                    # Docker関連ファイル
│   ├── docker-compose.yml    # 開発環境用Docker Compose設定
│   ├── Dockerfile.dev        # 開発環境用Dockerfile
│   ├── init.sql              # PostgreSQL初期化スクリプト
│   └── .dockerignore         # Docker用.gitignore
├── app/                      # Railsアプリケーション
├── config/                   # 設定ファイル
├── db/                       # データベース関連
└── docker-compose.yml        # メインのDocker Compose設定
```

### 手動セットアップ

1. 依存関係をインストール
```bash
bundle install
yarn install
```

2. データベースをセットアップ
```bash
bundle exec ridgepole -c config/database.yml -E development --apply -f db/Schemafile.rb
bundle exec rails db:seed
```

3. アプリケーションを起動
```bash
rails server
```

## 便利なコマンド

```bash
# すべてのサービスを起動
make up

# アプリケーションのログを表示
make logs

# アプリケーションコンテナに入る
make shell

# データベースコンテナに入る
make db-shell

# アプリケーションを再起動
make restart

# すべてのコンテナを停止
make down

# データベースマイグレーション
make migrate

# シードデータを投入
make seed

# Railsコンソールを起動
make console

# テストを実行
make test
```

## テスト用アカウント

- 管理者: `admin@example.com` / `password123`
- 一般ユーザー: `user@example.com` / `password123`

## 開発環境

開発環境では以下のサービスが利用できます：

- **Rails アプリケーション**: http://localhost:3000
- **PostgreSQL**: localhost:5432
- **Redis**: localhost:6379

## 本番環境

本番環境ではKamalを使用してデプロイできます：

```bash
kamal setup
kamal deploy
```

## ライセンス

MIT License
