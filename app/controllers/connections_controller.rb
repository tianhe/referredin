class ConnectionsController < ApplicationController
  before_filter :authenticate_user!

  def search
  end

  def csv
    redirect_to "/connections/#{params[:company]}"
  end

  def show
    return unless auth = current_user.authentications.where(provider: 'linkedin').first
    helper = LinkedInHelper.new(auth)

    profiles = helper.company_profiles(params[:id], params[:start_id] || 0)
    profiles = helper.expand_company_profiles(profiles)

    connections = LinkedInHelper.parse_company_profiles(profiles)

    respond_to do |format|
      format.csv { render text: LinkedInHelper.to_csv(connections) }
    end
  end
end
