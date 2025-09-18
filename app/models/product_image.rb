class ProductImage < ApplicationRecord
  belongs_to :product

  validates :image, presence: true

  scope :ordered, -> { order(:position) }
end
