class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 1000 }
  validates :user_id, uniqueness: { scope: :product_id, message: "は既にこの商品のレビューを投稿しています" }

  scope :recent, -> { order(created_at: :desc) }
  scope :high_rating, -> { where(rating: 4..5) }
  scope :low_rating, -> { where(rating: 1..2) }

  def rating_stars
    "★" * rating + "☆" * (5 - rating)
  end

  def can_be_edited_by?(user)
    user == self.user
  end

  def can_be_deleted_by?(user)
    user == self.user || user&.admin?
  end
end
