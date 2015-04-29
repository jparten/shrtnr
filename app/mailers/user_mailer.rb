class UserMailer < ApplicationMailer
  default from: "mail@benwoodall.com"

  def welcome_email(user)
    @user = user
    mail(to: user.email, subject: "Welcome to Shortener!")
  end

end
