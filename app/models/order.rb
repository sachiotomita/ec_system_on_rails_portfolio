class Order < ApplicationRecord
  belongs_to :user, optional: true
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :order_number, presence: true, uniqueness: true
  validates :subtotal, presence: true, numericality: { greater_than: 0 }
  validates :total_amount, presence: true, numericality: { greater_than: 0 }
  
  # ゲスト注文用のバリデーション
  validates :guest_name, presence: true, if: -> { user.nil? }
  validates :guest_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, if: -> { user.nil? }
  validates :guest_phone, presence: true, if: -> { user.nil? }

  before_validation :generate_order_number, on: :create
  before_validation :calculate_totals

  enum :status, {
    pending: 'pending',
    processing: 'processing',
    shipped: 'shipped',
    delivered: 'delivered',
    cancelled: 'cancelled'
  }

  enum :payment_status, {
    payment_pending: 'pending',
    paid: 'paid',
    failed: 'failed',
    refunded: 'refunded'
  }

  def add_items_from_cart(cart)
    cart.cart_items.each do |cart_item|
      order_items.create!(
        product: cart_item.product,
        product_name: cart_item.product.name,
        unit_price: cart_item.product.current_price,
        quantity: cart_item.quantity,
        total_price: cart_item.total_price
      )
    end
  end

  def can_cancel?
    pending? || processing?
  end

  private

  def generate_order_number
    self.order_number = "ORD-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
  end

  def calculate_totals
    self.total_amount = subtotal + tax_amount + shipping_amount
  end
end
