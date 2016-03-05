class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
 # before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:admin, :first_name, :last_name, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_me) }
    #devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:first_name, :last_name, :description, :email, :password, :password_confirmation, :current_password) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit! }
  end

  def authenticate_user
    if !user_signed_in?
      render template: 'pages/open_modal'
    end
  end

  def restrict_admin
    if current_user.try(:admin?)
      redirect_to events_path
    end
  end

  def authenticate_admin
    if !current_user.try(:admin?)
      redirect_to root_path
    end
  end

   def month_diff(start_date, end_date)
    months = []
    # months.push(start_date.month)
    diff = (end_date.month) - (start_date.month)

    if (diff < 0)
      gap = 12 + diff - 1
      cur = start_date.month
      counter = 0
      while ((counter < gap) && (cur != 12)) do
        months.push(cur)
        cur = cur+1
      end
      months.push(cur)
      cur = 1
      months.push(cur)
      while (cur < (gap-counter)) do
        cur = cur+1
        months.push(cur)
      end
    end
    return months

  end
end
