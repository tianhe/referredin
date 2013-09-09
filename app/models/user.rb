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

  def self.find_with_linkedin_oauth auth
    return unless authentication = Authentication.where(provider: auth.provider, uid: auth.uid).first
    authentication.user
  end

  def self.create_with_linkedin_oauth auth
    user = User.where(email: auth.info.email).first_or_initialize
    user.password = Devise.friendly_token
    user.save

    authentication = Authentication.where(provider: auth.provider, uid: auth.uid).first_or_initialize
    authentication.user = user
    authentication.secret = auth['credentials']['secret']
    authentication.token = auth['credentials']['token']
    authentication.save

    user
  end

end
