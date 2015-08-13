class ContactMailer < ApplicationMailer

  def new_contact(name, email, subject, content)
    @name = name
    @email = email
    @subject = subject
    @content = content

    email_with_name = "#{@name} <#{@email}>"
    mail(to: 'app.admin@someemail.com', subject: @subject, from: @email, reply_to: @email)
  end
end
