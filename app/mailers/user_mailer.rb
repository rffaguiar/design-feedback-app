class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email(user)
    @user = user
    if Rails.env.development?
      @url = 'http://localhost:3000/login'
    elsif Rails.env.production?
      @url = 'http://your_domain.domain/login'
    end

    mail(to: @user.email, subject: 'Bem vindo ao Design Feedback')
  end

end
