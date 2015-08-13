class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end

    def after_sign_in_path_for(resource)
      if session['design_id_before_register']
        @design = Design.find(session['design_id_before_register'])
        session.delete(:design_id_before_register)
        session.delete(:design_username_before_register)
        if Rails.env.development?
          path = 'http://localhost:3000/' + @design.link
        elsif Rails.env.production?
          path = 'http://designfeedback.com.br/' + @design.link
        end
      else
        path = individuais_path
      end
      path
    end
end
