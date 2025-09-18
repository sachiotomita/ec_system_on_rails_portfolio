# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# 管理者ユーザーの作成
admin_user = User.find_or_initialize_by(email: 'admin@example.com')
admin_user.password = 'password123'
admin_user.password_confirmation = 'password123'
admin_user.first_name = 'Admin'
admin_user.last_name = 'User'
admin_user.admin = true
admin_user.save!

# 一般ユーザーの作成
user = User.find_or_initialize_by(email: 'user@example.com')
user.password = 'password123'
user.password_confirmation = 'password123'
user.first_name = 'Test'
user.last_name = 'User'
user.phone = '090-1234-5678'
user.address = '東京都渋谷区1-1-1'
user.city = '渋谷区'
user.state = '東京都'
user.postal_code = '150-0001'
user.save!

# カテゴリの作成
categories = [
  { name: 'エレクトロニクス', description: 'スマートフォン、タブレット、PCなどの電子機器' },
  { name: 'ファッション', description: '服、靴、アクセサリーなどのファッションアイテム' },
  { name: 'ホーム&キッチン', description: '家具、家電、キッチン用品など' },
  { name: 'スポーツ&アウトドア', description: 'スポーツ用品、アウトドアグッズなど' },
  { name: '本&メディア', description: '書籍、DVD、CDなどのメディア' }
]

categories.each do |cat_data|
  category = Category.find_or_initialize_by(name: cat_data[:name])
  category.description = cat_data[:description]
  # 日本語のスラッグを手動で設定
  category.slug = case cat_data[:name]
  when 'エレクトロニクス'
    'electronics'
  when 'ファッション'
    'fashion'
  when 'ホーム&キッチン'
    'home-kitchen'
  when 'スポーツ&アウトドア'
    'sports-outdoor'
  when '本&メディア'
    'books-media'
  else
    cat_data[:name].parameterize
  end
  
  puts "Creating category: #{cat_data[:name]} with slug: #{category.slug}"
  
  unless category.save
    puts "Category validation errors: #{category.errors.full_messages}"
  end
end

# 商品の作成
electronics_category = Category.find_by(name: 'エレクトロニクス')
fashion_category = Category.find_by(name: 'ファッション')
home_category = Category.find_by(name: 'ホーム&キッチン')
sports_category = Category.find_by(name: 'スポーツ&アウトドア')
books_category = Category.find_by(name: '本&メディア')

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
  },
  # スポーツ&アウトドアカテゴリの商品
  {
    name: 'ヨガマット プロ',
    description: '高品質なTPE素材を使用した滑りにくいヨガマット。厚さ6mmで快適な練習ができます。',
    short_description: '高品質ヨガマット',
    price: 4500,
    sku: 'YOGA-MAT-PRO-001',
    stock_quantity: 80,
    category: sports_category,
    featured: true
  },
  {
    name: '登山用リュックサック 40L',
    description: '軽量で耐久性の高い登山用リュックサック。複数のポケットと快適な背負い心地を実現。',
    short_description: '登山用リュックサック',
    price: 12000,
    sku: 'HIKING-BACKPACK-40L-001',
    stock_quantity: 25,
    category: sports_category
  },
  {
    name: 'ランニングシューズ エアマックス',
    description: '快適なクッション性と軽量性を兼ね備えたランニングシューズ。',
    short_description: 'ランニングシューズ',
    price: 18000,
    sku: 'RUNNING-SHOES-AIRMAX-001',
    stock_quantity: 60,
    category: sports_category
  },
  # 本&メディアカテゴリの商品
  {
    name: 'プログラミング入門書',
    description: '初心者向けのプログラミング学習書。実践的な例題と丁寧な解説で基礎から学べます。',
    short_description: 'プログラミング入門書',
    price: 2800,
    sku: 'PROGRAMMING-BOOK-001',
    stock_quantity: 100,
    category: books_category,
    featured: true
  },
  {
    name: 'Bluetooth ワイヤレスイヤホン',
    description: '高音質で長時間使用可能なBluetoothイヤホン。ノイズキャンセリング機能付き。',
    short_description: 'Bluetoothイヤホン',
    price: 8500,
    sku: 'BLUETOOTH-EARPHONES-001',
    stock_quantity: 40,
    category: books_category
  },
  {
    name: 'Kindle Paperwhite',
    description: '目に優しい電子書籍リーダー。防水機能付きでどこでも読書を楽しめます。',
    short_description: 'Kindle Paperwhite',
    price: 15000,
    sku: 'KINDLE-PAPERWHITE-001',
    stock_quantity: 30,
    category: books_category
  }
]

products.each do |product_data|
  product = Product.find_or_initialize_by(sku: product_data[:sku])
  product.name = product_data[:name]
  product.description = product_data[:description]
  product.short_description = product_data[:short_description]
  product.price = product_data[:price]
  product.sale_price = product_data[:sale_price] if product_data[:sale_price]
  product.stock_quantity = product_data[:stock_quantity]
  product.category = product_data[:category]
  product.featured = product_data[:featured] || false
  # 商品のスラッグを手動で設定
  product.slug = case product_data[:name]
  when 'iPhone 15 Pro'
    'iphone-15-pro'
  when 'MacBook Air M2'
    'macbook-air-m2'
  when 'Nike Air Max 270'
    'nike-air-max-270'
  when '無印良品 ソファ'
    'muji-sofa'
  when 'Dyson V15 Detect'
    'dyson-v15-detect'
  when 'ヨガマット プロ'
    'yoga-mat-pro'
  when '登山用リュックサック 40L'
    'hiking-backpack-40l'
  when 'ランニングシューズ エアマックス'
    'running-shoes-airmax'
  when 'プログラミング入門書'
    'programming-book'
  when 'Bluetooth ワイヤレスイヤホン'
    'bluetooth-earphones'
  when 'Kindle Paperwhite'
    'kindle-paperwhite'
  else
    product_data[:name].parameterize
  end
  product.save!
  
  # 商品画像を追加（picsum.photosを使用）
  case product_data[:name]
  when 'iPhone 15 Pro'
    # メイン画像
    product.product_images.create!(
      image: 'https://picsum.photos/400/300?random=1',
      alt_text: 'iPhone 15 Pro フロント',
      position: 1,
      primary: true
    )
    # 追加画像
    product.product_images.create!(
      image: 'https://picsum.photos/400/300?random=2',
      alt_text: 'iPhone 15 Pro バック',
      position: 2,
      primary: false
    )
    product.product_images.create!(
      image: 'https://picsum.photos/400/300?random=3',
      alt_text: 'iPhone 15 Pro サイド',
      position: 3,
      primary: false
    )
  when 'MacBook Air M2'
    product.product_images.create!(
      image: 'https://picsum.photos/400/300?random=4',
      alt_text: 'MacBook Air M2',
      position: 1,
      primary: true
    )
    product.product_images.create!(
      image: 'https://picsum.photos/400/300?random=5',
      alt_text: 'MacBook Air M2 開いた状態',
      position: 2,
      primary: false
    )
  when 'Nike Air Max 270'
    product.product_images.create!(
      image: 'https://picsum.photos/400/300?random=6',
      alt_text: 'Nike Air Max 270',
      position: 1,
      primary: true
    )
    product.product_images.create!(
      image: 'https://picsum.photos/400/300?random=7',
      alt_text: 'Nike Air Max 270 サイド',
      position: 2,
      primary: false
    )
  when '無印良品 ソファ'
    product.product_images.create!(
      image: 'https://picsum.photos/400/300?random=8',
      alt_text: '無印良品 ソファ',
      position: 1,
      primary: true
    )
    product.product_images.create!(
      image: 'https://picsum.photos/400/300?random=9',
      alt_text: '無印良品 ソファ 詳細',
      position: 2,
      primary: false
    )
  when 'Dyson V15 Detect'
    product.product_images.create!(
      image: 'https://picsum.photos/400/300?random=10',
      alt_text: 'Dyson V15 Detect',
      position: 1,
      primary: true
    )
    product.product_images.create!(
      image: 'https://picsum.photos/400/300?random=11',
      alt_text: 'Dyson V15 Detect アクセサリー',
      position: 2,
      primary: false
    )
  when 'ヨガマット プロ'
    product.product_images.create!(
      image: 'https://picsum.photos/400/300?random=12',
      alt_text: 'ヨガマット プロ',
      position: 1,
      primary: true
    )
    product.product_images.create!(
      image: 'https://picsum.photos/400/300?random=13',
      alt_text: 'ヨガマット プロ 詳細',
      position: 2,
      primary: false
    )
  when '登山用リュックサック 40L'
    product.product_images.create!(
      image: 'https://picsum.photos/400/300?random=14',
      alt_text: '登山用リュックサック 40L',
      position: 1,
      primary: true
    )
  when 'ランニングシューズ エアマックス'
    product.product_images.create!(
      image: 'https://picsum.photos/400/300?random=15',
      alt_text: 'ランニングシューズ エアマックス',
      position: 1,
      primary: true
    )
    product.product_images.create!(
      image: 'https://picsum.photos/400/300?random=16',
      alt_text: 'ランニングシューズ エアマックス サイド',
      position: 2,
      primary: false
    )
  when 'プログラミング入門書'
    product.product_images.create!(
      image: 'https://picsum.photos/400/300?random=17',
      alt_text: 'プログラミング入門書',
      position: 1,
      primary: true
    )
  when 'Bluetooth ワイヤレスイヤホン'
    product.product_images.create!(
      image: 'https://picsum.photos/400/300?random=18',
      alt_text: 'Bluetooth ワイヤレスイヤホン',
      position: 1,
      primary: true
    )
    product.product_images.create!(
      image: 'https://picsum.photos/400/300?random=19',
      alt_text: 'Bluetooth ワイヤレスイヤホン ケース',
      position: 2,
      primary: false
    )
  when 'Kindle Paperwhite'
    product.product_images.create!(
      image: 'https://picsum.photos/400/300?random=20',
      alt_text: 'Kindle Paperwhite',
      position: 1,
      primary: true
    )
    product.product_images.create!(
      image: 'https://picsum.photos/400/300?random=21',
      alt_text: 'Kindle Paperwhite 背面',
      position: 2,
      primary: false
    )
  end
end

puts "シードデータの作成が完了しました！"
puts "- 管理者ユーザー: admin@example.com / password123"
puts "- 一般ユーザー: user@example.com / password123"
puts "- カテゴリ: #{Category.count}件"
puts "- 商品: #{Product.count}件"
puts "- 商品画像: #{ProductImage.count}件"
