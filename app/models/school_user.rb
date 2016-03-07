class SchoolUser < ActiveRecord::Base

  has_secure_password

  belongs_to :role
  belongs_to :school
  belongs_to :activity

  has_many :classroom
  has_many :event
end
