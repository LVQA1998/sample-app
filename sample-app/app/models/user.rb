class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.email_regex
  before_save :downcase_email
  validates :name, presence: true, length: {maximum: Settings.name.maximum}
  validates :email, presence: true, length: {maximum: Settings.email.maximum}, format: {with: VALID_EMAIL_REGEX}, uniqueness: true
  has_secure_password
  validates :password, presence: true, length: {minimum: Settings.password.minimum}
  private
  def downcase_email
    email.downcase!
  end
end
