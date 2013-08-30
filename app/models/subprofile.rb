class Subprofile < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :country, :headline, :industry, :location, :picture_url, :profile_id, :identifier, :provider, :public_profile_url, :specialties, :summary, :positions, :num_connections
  belongs_to :profile
  delegate :user, to: :profile
  validates :identifier, uniqueness: { scope: :provider }
  after_create :create_or_update_profile

  def find_profile
    return profile if profile
    Profile.where(first_name: first_name, last_name: last_name, location: location).first
  end

  private

  def create_or_update_profile
    profile_attributes = Profile.accessible_attributes.to_a
    lnkd_num_connections = self.attributes['num_connections']
    subprofile_attributes = self.attributes.slice *profile_attributes

    if self.profile = find_profile
      self.profile.update_attributes subprofile_attributes
    else
      self.profile = Profile.create subprofile_attributes.merge num_linkedin_connections: lnkd_num_connections
      save
    end

    self.profile
  end

end
