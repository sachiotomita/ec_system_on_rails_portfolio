# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# 管理者ユーザーの作成
admin_user = User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.first_name = 'Admin'
  user.last_name = 'User'
  user.admin = true
end

# 一般ユーザーの作成
user = User.find_or_create_by!(email: 'user@example.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.first_name = 'Test'
  user.last_name = 'User'
  user.phone = '090-1234-5678'
  user.address = '東京都渋谷区1-1-1'
  user.city = '渋谷区'
  user.state = '東京都'
  user.postal_code = '150-0001'
end

# カテゴリの作成
categories = [
  { name: 'エレクトロニクス', description: 'スマートフォン、タブレット、PCなどの電子機器' },
  { name: 'ファッション', description: '服、靴、アクセサリーなどのファッションアイテム' },
  { name: 'ホーム&キッチン', description: '家具、家電、キッチン用品など' },
  { name: 'スポーツ&アウトドア', description: 'スポーツ用品、アウトドアグッズなど' },
  { name: '本&メディア', description: '書籍、DVD、CDなどのメディア' }
]

categories.each do |cat_data|
  Category.find_or_create_by!(name: cat_data[:name]) do |category|
    category.description = cat_data[:description]
    category.slug = cat_data[:name].parameterize
  end
end

# 商品の作成
electronics_category = Category.find_by(name: 'エレクトロニクス')
fashion_category = Category.find_by(name: 'ファッション')
home_category = Category.find_by(name: 'ホーム&キッチン')

products = [
  {
    name: 'iPhone 15 Pro',
    description: '最新のiPhone 15 Pro。A17 Proチップを搭載し、カメラ性能も大幅に向上しました。',
    short_description: '最新のiPhone 15 Pro',
    price: 134800,
    sale_price: 124800,
    sku: 'IPHONE15PRO-001',
    stock_quantity: 50,
    category: electronics_category,
    featured: true
  },
  {
    name: 'MacBook Air M2',
    description: 'M2チップを搭載したMacBook Air。軽量で高性能なノートパソコンです。',
    short_description: 'M2チップ搭載MacBook Air',
    price: 148800,
    sku: 'MACBOOKAIR-M2-001',
    stock_quantity: 30,
    category: electronics_category,
    featured: true
  },
  {
    name: 'Nike Air Max 270',
    description: '快適なクッション性とスタイリッシュなデザインのスニーカー。',
    short_description: 'Nike Air Max 270',
    price: 15000,
    sku: 'NIKE-AIRMAX270-001',
    stock_quantity: 100,
    category: fashion_category
  },
  {
    name: '無印良品 ソファ',
    description: 'シンプルで機能的な無印良品のソファ。リビングにぴったりです。',
    short_description: '無印良品 ソファ',
    price: 45000,
    sku: 'MUJI-SOFA-001',
    stock_quantity: 20,
    category: home_category
  },
  {
    name: 'Dyson V15 Detect',
    description: 'レーザー技術を搭載したDysonの最新コードレス掃除機。',
    short_description: 'Dyson V15 Detect',
    price: 85000,
    sku: 'DYSON-V15-001',
    stock_quantity: 15,
    category: home_category,
    featured: true
  }
]

products.each do |product_data|
  Product.find_or_create_by!(sku: product_data[:sku]) do |product|
    product.name = product_data[:name]
    product.description = product_data[:description]
    product.short_description = product_data[:short_description]
    product.price = product_data[:price]
    product.sale_price = product_data[:sale_price] if product_data[:sale_price]
    product.stock_quantity = product_data[:stock_quantity]
    product.category = product_data[:category]
    product.featured = product_data[:featured] || false
    product.slug = product_data[:name].parameterize
  end
end

puts "シードデータの作成が完了しました！"
puts "- 管理者ユーザー: admin@example.com / password123"
puts "- 一般ユーザー: user@example.com / password123"
puts "- カテゴリ: #{Category.count}件"
puts "- 商品: #{Product.count}件"
