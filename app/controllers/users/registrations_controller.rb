class Users::RegistrationsController < Devise::RegistrationsController
before_filter :configure_sign_up_params, only: [:create]
before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    if session['design_id_before_register']
      @design = Design.find(session['design_id_before_register'])
    end
    super
  end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # You can put the params you want to permit in the empty array.
    def configure_sign_up_params
      # devise_parameter_sanitizer.for(:sign_up) << :name
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(:name, :email, :password, :password_confirmation)
      end
    end

  # You can put the params you want to permit in the empty array.
    def configure_account_update_params
      # devise_parameter_sanitizer.for(:account_update) << :name
      devise_parameter_sanitizer.for(:account_update) do |u|
        u.permit(:name, :email, :password, :password_confirmation, :current_password)
      end
    end

  # The path used after sign up.
  def after_sign_up_path_for(resource)

    if session['design_id_before_register'] && user_signed_in?
      @design = Design.find(session['design_id_before_register'])
      session.delete(:design_id_before_register)
      session.delete(:design_username_before_register)
      if Rails.env.development?
        path = 'http://localhost:3000/' + @design.link
      elsif Rails.env.production?
        path = 'http://designfeedback.com.br/' + @design.link
      end
    else
      path = root_url
    end
    path
    # super(resource)
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
