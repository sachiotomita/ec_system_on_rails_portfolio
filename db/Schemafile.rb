# データベーススキーマ定義ファイル
# ridgepoleを使用してスキーマを管理

create_table :users, force: :cascade do |t|
  t.string :email, null: false, default: ""
  t.string :encrypted_password, null: false, default: ""
  t.string :first_name, null: false
  t.string :last_name, null: false
  t.string :phone
  t.text :address
  t.string :city
  t.string :state
  t.string :postal_code
  t.string :country, default: "Japan"
  t.boolean :admin, default: false
  t.string :reset_password_token
  t.datetime :reset_password_sent_at
  t.datetime :remember_created_at
  t.timestamps null: false
end

add_index :users, :email, unique: true
add_index :users, :reset_password_token, unique: true

create_table :categories, force: :cascade do |t|
  t.string :name, null: false
  t.text :description
  t.string :slug, null: false
  t.boolean :active, default: true
  t.timestamps null: false
end

add_index :categories, :slug, unique: true
add_index :categories, :active

create_table :products, force: :cascade do |t|
  t.string :name, null: false
  t.text :description
  t.text :short_description
  t.decimal :price, precision: 10, scale: 2, null: false
  t.decimal :sale_price, precision: 10, scale: 2
  t.string :sku, null: false
  t.integer :stock_quantity, default: 0
  t.boolean :active, default: true
  t.boolean :featured, default: false
  t.string :slug, null: false
  t.integer :category_id, null: false
  t.timestamps null: false
end

add_index :products, :sku, unique: true
add_index :products, :slug, unique: true
add_index :products, :active
add_index :products, :featured
add_index :products, :category_id

create_table :product_images, force: :cascade do |t|
  t.integer :product_id, null: false
  t.string :image, null: false
  t.string :alt_text
  t.integer :position, default: 0
  t.boolean :primary, default: false
  t.timestamps null: false
end

add_index :product_images, :product_id
add_index :product_images, :position

create_table :carts, force: :cascade do |t|
  t.integer :user_id, null: false
  t.timestamps null: false
end

add_index :carts, :user_id, unique: true

create_table :cart_items, force: :cascade do |t|
  t.integer :cart_id, null: false
  t.integer :product_id, null: false
  t.integer :quantity, null: false, default: 1
  t.timestamps null: false
end

add_index :cart_items, :cart_id
add_index :cart_items, :product_id
add_index :cart_items, [:cart_id, :product_id], unique: true

create_table :orders, force: :cascade do |t|
  t.integer :user_id, null: false
  t.string :order_number, null: false
  t.decimal :subtotal, precision: 10, scale: 2, null: false
  t.decimal :tax_amount, precision: 10, scale: 2, default: 0
  t.decimal :shipping_amount, precision: 10, scale: 2, default: 0
  t.decimal :total_amount, precision: 10, scale: 2, null: false
  t.string :status, default: "pending"
  t.string :shipping_address
  t.string :billing_address
  t.string :payment_method
  t.string :payment_status, default: "pending"
  t.datetime :shipped_at
  t.datetime :delivered_at
  t.timestamps null: false
end

add_index :orders, :user_id
add_index :orders, :order_number, unique: true
add_index :orders, :status

create_table :order_items, force: :cascade do |t|
  t.integer :order_id, null: false
  t.integer :product_id, null: false
  t.string :product_name, null: false
  t.decimal :unit_price, precision: 10, scale: 2, null: false
  t.integer :quantity, null: false
  t.decimal :total_price, precision: 10, scale: 2, null: false
  t.timestamps null: false
end

add_index :order_items, :order_id
add_index :order_items, :product_id

create_table :reviews, force: :cascade do |t|
  t.references :user, null: false, foreign_key: true
  t.references :product, null: false, foreign_key: true
  t.integer :rating, null: false
  t.string :title, null: false, limit: 100
  t.text :content, null: false, limit: 1000
  t.timestamps null: false
end

add_index :reviews, [:user_id, :product_id], unique: true
add_index :reviews, :rating
add_index :reviews, :created_at

# 外部キー制約
add_foreign_key :products, :categories
add_foreign_key :product_images, :products
add_foreign_key :carts, :users
add_foreign_key :cart_items, :carts
add_foreign_key :cart_items, :products
add_foreign_key :orders, :users
add_foreign_key :order_items, :orders
add_foreign_key :order_items, :products
