class LinkUsersJob
  @queue = :linkedin

  def self.perform user_id
    puts "Link User: #{user_id}"
    user = User.find(user_id)
    return unless authentication = user.authentications.where(provider: 'linkedin').first

    linkedin_helper = LinkedInHelper.new(authentication)

    #LinkedIn API Requests
    connections = linkedin_helper.personal_connections
    profile = linkedin_helper.personal_profile

    #Create User Profile
    user_profile_attrs = LinkedInHelper.parse_profile(profile)
    user_profile_attrs.merge(num_connections: connections.count)
    user_subprofile = Subprofile.create(user_profile_attrs)
    user.profile = user_subprofile.profile

    #Create Connections
    connection_attrs = LinkedInHelper.parse_personal_connections(connections)
    user.connect(connection_attrs)

    puts "Found #{connections.all.count} connections, Created profiles for: #{user.user_contacts.count}"
  end

end
