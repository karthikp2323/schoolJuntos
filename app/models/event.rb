class Event < ActiveRecord::Base
  
  

  belongs_to :school_users
  belongs_to :classroom
end
