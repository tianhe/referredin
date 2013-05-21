# class SessionsController < ApplicationController

#   def new
#   end

#   def create
#     authentication = Authentication.where(provider: auth_hash['provider'], uid: auth_hash['uid']).first_or_initialize
#     authentication.token = auth_hash['credentials']['token']
#     authentication.save

#     unless @user = authentication.user
#       @user = User.create
#       @user.authentications << authentication
#       handle_linkedin(@user) if auth_hash['provider'] == 'linkedin'
#     end

#     redirect_to '/'
#   end

#   protected

#   def handle_linkedin user
#     client = LinkedIn::Client.new
#     client.authorize_from_access(auth_hash['credentials']['token'], auth_hash['credentials']['secret'])

#     profile = client.profile(fields: %w(first_name last_name location industry picture_url public_profile_url))
#     user.profiles.create LinkedInHelper.parse_profile(profile)
#     user.connect LinkedInHelper.parse_connections(client.connections.all)
#   end

#   def auth_hash
#     request.env['omniauth.auth']
#   end
# end