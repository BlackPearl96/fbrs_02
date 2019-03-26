class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user
  has_many :comments, dependent: :destroy

  delegate :name, to: :user, prefix: :user, allow_nil: true

  validates :content, presence: true,
   length: {maximum: Settings.review.max_length}
  validates :user_id, presence: true
  validates :book_id, presence: true

  scope :ordered, ->{order created_at: :DESC}
end
