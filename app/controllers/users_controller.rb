class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = User.find(params[:id])
    @facet = params[:facet] || 'industry'
    @rankings = @user.contacts.order_by_count(@facet)
  end
end
