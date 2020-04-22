class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  USER_PARAMS = [:name, :email, :password, :password_confirmation].freeze
  VALID_EMAIL_REGEX = Settings.email_regex

  before_save :downcase_email
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
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false unless remember_digest
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute :remember_digest, nil
  end
  
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
  
  def activate
    update_columns activated: FILL_IN, activated_at: FILL_IN
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def forget
    update_attribute :remember_digest, nil
  end

  private

  def downcase_email
    email.downcase!
  end
end
