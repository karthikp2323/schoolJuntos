class Event < ActiveRecord::Base
  belongs_to :school_users
  belongs_to :classroom

  attr_accessor :acceptedCount
  attr_accessor :rejectedCount
end
 