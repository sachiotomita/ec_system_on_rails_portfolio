class Product < ApplicationRecord
  belongs_to :category
  has_many :product_images, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :sku, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(active: true) }
  scope :featured, -> { where(featured: true) }
  scope :in_stock, -> { where('stock_quantity > 0') }

  before_validation :generate_slug

  def primary_image
    product_images.find_by(primary: true) || product_images.first
  end

  def current_price
    sale_price.present? ? sale_price : price
  end

  def on_sale?
    sale_price.present? && sale_price < price
  end

  def in_stock?
    stock_quantity > 0
  end

  private

  def generate_slug
    self.slug = name.parameterize if slug.blank?
  end
end
