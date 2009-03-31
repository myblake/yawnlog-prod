class UserLogin < ActiveRecord::Base
  has_one :user
  belongs_to :user
  validates_presence_of :username
	validates_presence_of :password
end
