class UserContact < ActiveRecord::Base
  attr_accessible :contact_id, :user_id
  belongs_to :user
  belongs_to :contact, class_name: 'Profile', foreign_key: 'contact_id'

  validates_presence_of   :user
  validates_presence_of   :contact
  validates_uniqueness_of :contact_id, scope: :user_id
end
