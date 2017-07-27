class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("user.mailer.activation")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t("user.mailer.reset_pass")
  end
end
