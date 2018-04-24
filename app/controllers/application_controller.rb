class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :group, :logged_in?, :current_user, :current_is_member?, :user_is_member?

  def logged_in?
    session[:user_id]
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if logged_in?
  end

  def current_is_member?(group)
    @current_user = current_user
    @current_user.groups.include?(group)
  end

  def user_is_member?(user, group)
    user.groups.include?(group)
  end

  def group(group_id)
    Group.find(group_id)
  end

  def authenticate_user
    redirect_to root_path unless logged_in?
  end
end
