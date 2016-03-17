class Auth::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters

  protected
  def after_sign_up_path_for(resource)
    :new_user_session
  end

  def after_inactive_sign_up_path_for(resource)
    after_sign_up_path_for resource
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:email, :password, :password_confirmation, :name, :username)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:email, :password, :password_confirmation, :name, :username)
    end
  end

end
