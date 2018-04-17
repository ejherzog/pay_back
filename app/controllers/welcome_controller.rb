class WelcomeController < ApplicationController
  def index
    return unless logged_in?
  end
end
