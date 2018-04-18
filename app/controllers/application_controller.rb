class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :logged_in?, :current_user, :member?

  def logged_in?
    session[:user_id]
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if logged_in?
  end

  def member?(group)
    @current_user = current_user
    print(@current_user.groups)
    @current_user.groups.include?(group)
  end

  def authenticate_user
    redirect_to root_path unless logged_in?
  end
end
