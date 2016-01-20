class Classroom < ActiveRecord::Base
  belongs_to :school
  belongs_to :school_user

  has_many :class_registration
end
