class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("user.mailer.activation")
  end

  def password_reset
    @greeting = t "user.mailer.hi"
    mail to: "to@example.org"
  end
end
