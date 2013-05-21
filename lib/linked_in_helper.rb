class LinkedInHelper

  def self.parse_profile profile
    { first_name:         profile.first_name,
      last_name:          profile.last_name,
      location:           profile.location.try(:name),
      country:            profile.location.try(:country).try(:code),
      industry:           profile.industry,
      picture_url:        profile.picture_url,
      headline:           profile.headline,
      public_profile_url: profile.public_profile_url,
      provider:           'linkedin',
      identifier:         profile.public_profile_url
    }
  end

  def self.parse_connections connections
    connections.map { |connection| self.parse_profile(connection) }
  end
end
