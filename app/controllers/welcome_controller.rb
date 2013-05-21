class WelcomeController < ApplicationController
  def index
    redirect_to user_url(current_user) and return if current_user
  end
end
