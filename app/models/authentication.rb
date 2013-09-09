class Authentication < ActiveRecord::Base
  attr_accessible :provider, :token, :uid, :user_id, :secret
  belongs_to :user

  validates :uid, uniqueness: { scope: :provider }
end
