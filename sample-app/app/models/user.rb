class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  USER_PARAMS = [:name, :email, :password, :password_confirmation].freeze
  VALID_EMAIL_REGEX = Settings.email_regex
  PASSWORD_PERMIT = [:password, :password_confirmation].freeze
  
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name, foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name, foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: {maximum: Settings.name.maximum}
  validates :email, presence: true, length: {maximum: Settings.email.maximum}, format: {with: VALID_EMAIL_REGEX}, uniqueness: true
  has_secure_password
  validates :password, presence: true, length: {minimum: Settings.password.minimum}, allow_nil: true

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attributes remember_digest: nil
  end

  def activate
    update_attribute activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attributes reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Settings.expired_hours.hours.ago
  end

  def feed
    Micropost.by_created_at.feed_by_following following_ids << id
  end

  def follow other_user
    following << other_user
  end
    
  def unfollow other_user
    following.delete other_user
  end
  
  def following? other_user
    following.include? other_user
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

end
