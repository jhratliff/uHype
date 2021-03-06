class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  respond_to :html, :json

  before_filter :configure_permitted_parameters, if: :devise_controller?

  acts_as_token_authentication_handler_for User

  private

  def configure_permitted_parameters
# Add my attributes added to the devise User class
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password,
                                                            :password_confirmation, :remember_me, :avatar, :avatar_cache,
                                                            :first_name, :last_name, :dob, :class_of) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password,
                                                                   :password_confirmation, :current_password, :avatar, :avatar_cache,
                                                                    :first_name, :last_name, :dob, :class_of) }
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

end
