class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
 # before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
    #devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:first_name, :last_name, :description, :email, :password, :password_confirmation, :current_password, :user_tags => [:tag]) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit! }
  end
end
