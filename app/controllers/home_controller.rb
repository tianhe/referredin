class HomeController < ApplicationController

  def index
    @user = current_user
    @facet = params[:facet]
    @rankings = @user.contacts.order_by_count(@facet)
  end

end
