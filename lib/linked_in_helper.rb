require 'csv'

class LinkedInHelper
  attr_accessor :client

  def initialize authentication
    @client = LinkedIn::Client.new
    @client.authorize_from_access(authentication.token, authentication.secret)
  end

  # Query Methods
  def personal_profile
    @client.profile(fields: %w(id first_name last_name location positions industry picture_url public_profile_url summary specialties))
  end

  def personal_connections
    @client.connections(fields: %w(id first_name last_name location industry positions picture_url public_profile_url num_connections summary)).all
  end

  def company_profiles company, start
    @client.search(
      fields: [{people: %w(id first_name last_name public_profile_url positions relation_to_viewer)}],
      facet: "network,F,S",
      "company-name" => company,
      "current-company" => true,
      "country-code" => 'us',
      count: 25,
      start: start,
       sort: 'distance').people.all
  end

  def expand_company_profiles profiles
    profiles.map do |profile|
      if profile.relation_to_viewer.try(:connections).nil? && profile.id != 'private'
        p = @client.profile(id: profile.id, fields: %w(relation_to_viewer))
        profile.relation_to_viewer = p.relation_to_viewer
      end
      profile
    end
  end

  # Helper Methods
  def self.parse_profile profile
    full_profile_info(profile)
  end

  def self.parse_profiles profiles
    profiles.map do |profile|
      full_profile_info(profile)
    end
  end

  def self.parse_company_profiles profiles
    profiles.map do |profile|
      prof = basic_profile_info(profile)
      prof.merge! position_info(profile.positions.all.first) if profile.positions && profile.positions.all
      prof.merge! relation_to_viewer_info(profile.relation_to_viewer) if profile.relation_to_viewer
    end
  end

  # Hash Templates
  def self.full_profile_info profile
    {
      first_name:         profile.first_name,
      last_name:          profile.last_name,
      public_profile_url: profile.public_profile_url,
      location:           profile.location.try(:name),
      country:            profile.location.try(:country).try(:code),
      industry:           profile.industry,
      picture_url:        profile.picture_url,
      headline:           profile.headline,
      provider:           'linkedin',
      identifier:         profile.public_profile_url,
      num_connections:    profile.num_connections
    }
  end

  def self.basic_profile_info profile
    {
      first_name:         profile.first_name,
      last_name:          profile.last_name,
      public_profile_url: profile.public_profile_url
    }
  end

  def self.relation_to_viewer_info relation_to_viewer
    return {} unless relation_to_viewer.connections && relation_to_viewer.connections.all
    {
      mutual_connections: relation_to_viewer.connections.total,
      connection_1:       full_name(relation_to_viewer.connections.all[0].try(:person)),
      connection_2:       full_name(relation_to_viewer.connections.all[1].try(:person)),
      connection_3:       full_name(relation_to_viewer.connections.all[2].try(:person))
    }
  end

  def self.full_name person
    "#{person.try(:first_name)} #{person.try(:last_name)}"
  end

  def self.position_info position
    {
      industry:   position.industry,
      company:    position.name,
      is_current: position.is_current,
      summary:    position.summary,
      title:      position.title
    }
  end

  def self.to_csv(options = {}, data)
    columns = data.compact.map{ |r| r.keys }.flatten.uniq

    CSV.generate(options) do |csv|
      csv << columns
      data.compact.each do |row|
        csv << row.values_at(*columns)
      end
    end
  end

  def self.to_file(file_name, data)
    columns = data.compact.map{ |r| r.keys }.flatten.uniq
    CSV.open(file_name, 'wb') do |csv|
      csv << columns
      data.compact.each do |row|
        csv << row.values_at(*columns)
      end
    end
  end
end
