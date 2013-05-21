class Subprofile < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :country, :headline, :industry, :location, :picture_url, :profile_id, :identifier, :provider, :public_profile_url
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
    subprofile_attributes = self.attributes.slice *profile_attributes

    if self.profile = find_profile
      self.profile.update_attributes subprofile_attributes
    else
      self.profile = Profile.create subprofile_attributes
      save
    end

    self.profile
  end

end
