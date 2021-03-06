class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable,
   :rememberable, :validatable, :omniauthable

  attr_accessor :remember_token, :activation_token, :reset_token
  has_many :reviews, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  # has_many :activities, dependent: :destroy
  # has_many :marks, dependent: :destroy
  has_many :suggests, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name,
   foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
   foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  validates :name, presence: true, length: {maximum: 50}

  scope :sort_by_name, ->{order :name}
  scope :activated, ->{where activated: true}
  scope :sort_by_created_at, ->{order created_at: :DESC}

  enum role: [:user, :admin]

  # Follows a user.
  def follow other_user
    following << other_user
  end

  # Unfollows a user.
  def unfollow other_user
    following.delete other_user
  end

  # Returns true if the current user is following the other user.
  def following? other_user
    following.include? other_user
  end

  def self.to_csv(options = {})
    attributes = %w{id name email}
    CSV.generate(options) do |csv|
      csv << attributes
      all.each do |user|
        csv << attributes.map{|attr| user.send(attr)}
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.picture = auth.info.image
      user.save
    end
  end
end
