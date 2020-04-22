class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("mailer.account_activation")
  end

  def password_reset
    mail to: Settings.reset_password_email
  end
end
