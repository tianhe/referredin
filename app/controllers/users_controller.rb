class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = User.find(params[:id])
    @facet = params[:facet] || 'industry'

    if @facet == 'connectors'
      @rankings = @user.contacts.order("num_linkedin_connections DESC").select("profiles.first_name || ' ' || profiles.last_name AS facet, num_linkedin_connections AS count")
    else
      @rankings = @user.contacts.order_by_count(@facet)
    end
  end
end
