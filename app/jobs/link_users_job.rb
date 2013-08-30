class LinkUsersJob
  @queue = :linkedin

  def self.perform id, auth
    User.find(id).handle_linkedin(auth)
  end
end