class LinkUsersJob
  @queue = :linkedin

  def self.perform id, auth
    client = User.find(id).linkedin_client(auth)
    User.find(id).handle_linkedin(client)
  end
end
