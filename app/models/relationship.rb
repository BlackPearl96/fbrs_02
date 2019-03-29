class Relationship < ApplicationRecord
  belongs_to :follower, class_name: User.name
  belongs_to :followed, class_name: User.name

  validates :follower_id, presence: true
  validates :followed_id, presence: true

  validate :not_following_himself

  def not_following_himself
    if followed_id == follower_id
      errors.add :followed_id
    end
  end
end
