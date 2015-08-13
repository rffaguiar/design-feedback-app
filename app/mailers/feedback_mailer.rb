class FeedbackMailer < ApplicationMailer

  default from: "DesignFeedback <no-reply@designfeedback.com.br>"

  def to_admin(feedback, user)
    @feedback = feedback
    @user = user
    mail(to: 'app.admin@someemail.com', subject: 'New Feedback',  reply_to: user.email)
  end

end
