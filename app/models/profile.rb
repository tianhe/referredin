class Profile < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :headline, :industry, :location, :country, :picture_url, :user_id, :num_linkedin_connections
  has_many :subprofiles
  belongs_to :user

  extend NetworkHelper
end
