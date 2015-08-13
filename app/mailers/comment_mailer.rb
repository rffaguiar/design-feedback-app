class CommentMailer < ApplicationMailer
  # default from: 'notifications@example.com'
  default from: "DesignFeedback <no-reply@designfeedback.com.br>"

  def new_comment(comment)
    @comment = comment
    email_with_name = "#{@comment.design.user.name} <#{@comment.design.user.email}>"
    mail(to: email_with_name, subject: 'Novo comentário no seu Design', reply_to: @comment.user.email)
  end
end
