class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:linkedin]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :authentications, dependent: :destroy
  has_one  :profile
  has_many :subprofiles, through: :profile
  has_many :user_contacts, dependent: :destroy
  has_many :contacts, through: :user_contacts, class_name: 'Profile'

  def connect contacts
    profiles = contacts.map do |contact|
      subprofile = Subprofile.where(identifier: contact[:identifier], provider: contact[:provider]).first_or_initialize
      subprofile.update_attributes(contact)
      subprofile.profile
    end

    self.contacts = (self.contacts + profiles.compact).uniq
  end

  def self.find_for_linkedin_oauth(auth)
    authentication = Authentication.where(provider: auth.provider, uid: auth.uid).first_or_initialize

    unless authentication.user
      user = User.where(email: auth.info.email).first
      unless user
        user = User.create(email: auth.info.email, password:  Devise.friendly_token)
        Resque.enqueue LinkUsersJob, user.id, auth
      end
      authentication.user = user
      authentication.save
    end

    authentication.user
  end

  def handle_linkedin auth
    client = LinkedIn::Client.new
    client.authorize_from_access(auth['credentials']['token'], auth['credentials']['secret'])

    lnkd_profile = client.profile(fields: %w(id first_name last_name location industry picture_url public_profile_url summary specialties))
    connections = client.connections(fields: %w(id first_name last_name location industry picture_url public_profile_url num_connections summary))

    subprofile = Subprofile.create LinkedInHelper.parse_profile(lnkd_profile).merge num_connections: connections.all.count
    self.profile = subprofile.profile

    self.connect LinkedInHelper.parse_connections(connections.all)
  end

end
