-- PostgreSQL初期化スクリプト
-- 開発環境用のデータベース設定

-- データベースの作成（既にdocker-compose.ymlで作成されるが、念のため）
CREATE DATABASE IF NOT EXISTS ec_fullscratch_on_rails_portfolio_development;
CREATE DATABASE IF NOT EXISTS ec_fullscratch_on_rails_portfolio_test;

-- ユーザーの権限設定
GRANT ALL PRIVILEGES ON DATABASE ec_fullscratch_on_rails_portfolio_development TO postgres;
GRANT ALL PRIVILEGES ON DATABASE ec_fullscratch_on_rails_portfolio_test TO postgres;
