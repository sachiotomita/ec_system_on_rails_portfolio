class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def total_items
    cart_items.sum(:quantity)
  end

  def total_price
    cart_items.sum { |item| item.quantity * item.product.current_price }
  end

  def empty?
    cart_items.empty?
  end

  def add_product(product, quantity = 1)
    cart_item = cart_items.find_by(product: product)
    
    if cart_item
      cart_item.update(quantity: cart_item.quantity + quantity)
    else
      cart_items.create(product: product, quantity: quantity)
    end
  end

  def remove_product(product)
    cart_items.find_by(product: product)&.destroy
  end

  def update_quantity(product, quantity)
    cart_item = cart_items.find_by(product: product)
    
    if quantity <= 0
      cart_item&.destroy
    else
      cart_item&.update(quantity: quantity)
    end
  end
end
