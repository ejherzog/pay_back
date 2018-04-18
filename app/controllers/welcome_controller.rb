class WelcomeController < ApplicationController
  def index
    return unless logged_in?
    @groups = current_user.groups
    @expenses = current_user.expenses
  end
end
