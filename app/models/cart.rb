require 'ostruct'

class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  # セッションベースのカート用の属性
  attr_accessor :session_items

  def initialize(attributes = {})
    super
    @session_items = {}
  end

  def total_items
    if persisted?
      cart_items.sum(:quantity)
    else
      session_items.values.sum
    end
  end

  def total_price
    if persisted?
      cart_items.sum { |item| item.quantity * item.product.current_price }
    else
      session_items.sum do |product_id, quantity|
        product = Product.find(product_id)
        quantity * product.current_price
      end
    end
  end

  def empty?
    if persisted?
      cart_items.empty?
    else
      session_items.empty?
    end
  end

  def add_product(product, quantity = 1)
    if persisted?
      cart_item = cart_items.find_by(product: product)
      
      if cart_item
        cart_item.update(quantity: cart_item.quantity + quantity)
      else
        cart_items.create(product: product, quantity: quantity)
      end
    else
      # セッションベースのカート
      product_id = product.id.to_s
      session_items[product_id] = (session_items[product_id] || 0) + quantity
    end
  end

  def remove_product(product)
    if persisted?
      cart_items.find_by(product: product)&.destroy
    else
      session_items.delete(product.id.to_s)
    end
  end

  def update_quantity(product, quantity)
    if persisted?
      cart_item = cart_items.find_by(product: product)
      
      if quantity <= 0
        cart_item&.destroy
      else
        cart_item&.update(quantity: quantity)
      end
    else
      product_id = product.id.to_s
      if quantity <= 0
        session_items.delete(product_id)
      else
        session_items[product_id] = quantity
      end
    end
  end

  def load_from_session(session_data)
    @session_items = session_data.dup
  end

  def save_to_session(session)
    session[:cart_items] = @session_items
  end

  def cart_items
    if persisted?
      super
    else
      # セッションベースのカート用の仮想的なcart_items
      session_items.map do |product_id, quantity|
        product = Product.find(product_id)
        OpenStruct.new(
          product: product,
          quantity: quantity,
          id: product_id
        )
      end
    end
  end
end
