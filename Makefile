# Docker Compose用のMakefile

.PHONY: help build up down logs shell db-shell clean setup

# デフォルトターゲット
help: ## 利用可能なコマンドを表示
	@echo "利用可能なコマンド:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

build: ## Dockerイメージをビルド
	docker-compose -f docker/docker-compose.yml build

up: ## すべてのサービスを起動
	docker-compose -f docker/docker-compose.yml up -d

down: ## すべてのサービスを停止
	docker-compose -f docker/docker-compose.yml down

logs: ## アプリケーションのログを表示
	docker-compose -f docker/docker-compose.yml logs -f app

shell: ## アプリケーションコンテナに入る
	docker-compose -f docker/docker-compose.yml exec app bash

db-shell: ## データベースコンテナに入る
	docker-compose -f docker/docker-compose.yml exec db psql -U postgres -d ec_fullscratch_on_rails_portfolio_development

setup: ## 初回セットアップを実行
	./bin/docker-setup

clean: ## すべてのコンテナとボリュームを削除
	docker-compose -f docker/docker-compose.yml down -v
	docker system prune -f

restart: ## アプリケーションを再起動
	docker-compose -f docker/docker-compose.yml restart app

migrate: ## データベースマイグレーションを実行
	docker-compose -f docker/docker-compose.yml exec app bundle exec ridgepole -c config/database.yml -E development --apply -f db/Schemafile.rb

seed: ## シードデータを投入
	docker-compose -f docker/docker-compose.yml exec app bundle exec rails db:seed

console: ## Railsコンソールを起動
	docker-compose -f docker/docker-compose.yml exec app bundle exec rails console

test: ## テストを実行
	docker-compose -f docker/docker-compose.yml exec app bundle exec rails test
