class StaticPagesController < ApplicationController

  def home
  end

  # used for get and post contact
  def contact
    if params[:name] && params[:email] && params[:subject] && params[:content]
      if verify_recaptcha
        flash.now[:email_sent] = true
        ContactMailer.new_contact(params[:name], params[:email], params[:subject], params[:content]).deliver_now
      else
        p 'erro de captcha!'
      end
    end

  end

end
