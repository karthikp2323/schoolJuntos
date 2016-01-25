class Api::EventsController < ApplicationController
after_action :set_access_control_headers
skip_before_action :verify_authenticity_token, only: [:create]


#GET Events
def getEvent
	
  @events = Event.all
	render json: @events

end

#GET Events for a particular class
def getEventForClass
	
	@events = Event.where("classroom_id = ?", params[:classroom_id])
	render json: @events

end

def getEventDetail
  
  #An OpenStruct is a data structure, similar to a Hash, 
  #that allows the definition of arbitrary attributes with their accompanying values. 
  #This is accomplished by using Ruby’s metaprogramming to define methods on the class itself.
  begin
    @eventObj = OpenStruct.new
    @event = Event.find(params[:eventId])
    
    @eventObj.event_title = @event.event_title
    @eventObj.event_description = @event.event_description
    @eventObj.event_date = @event.event_date
    @eventObj.event_time = @event.event_time
    @eventObj.event_location = @event.event_location
    @eventObj.school_user_id = @event.school_user_id
    @eventObj.classroom_id = @event.classroom_id
    
    #This query is performed in order to eliminate 
    #duplicate parent id that can be caused due to twin children 
     
    sql = "SELECT  COUNT(DISTINCT p.id)
           FROM class_registrations c
           JOIN students s
           ON s.id = c.student_id
           JOIN parents p
           ON p.id = s.parent_id
           WHERE c.classroom_id = " + @event.classroom_id.to_s
            
    records_array = ActiveRecord::Base.connection.exec_query(sql)
    @eventObj.invitationCount = records_array.rows 

    sql = "SELECT COUNT(parent_id_declined) as declineCount, 
           COUNT(parent_id) as acceptedCount 
           FROM `event_statuses` WHERE event_id = " + params[:eventId].to_s
    records_array = ActiveRecord::Base.connection.exec_query(sql)
    @eventObj.acceptedCount = records_array.rows[0][1]
    @eventObj.declinedCount = records_array.rows[0][0]
    #EventStatus.select(:parent_id).where("event_id =?", params[:eventId] ).count
    #@acceptedCount = ClassRegistration.joins(student: :parent).where("classroom_id =?", 2 )
    
    render json: @eventObj

  rescue Exception => e
    render json: e.message
  end
  
 
end

def eventUserDetailList

    begin
      selectedOption = params[:selectedOption]
      if selectedOption == 'Invited'
           
           sql = "SELECT DISTINCT p.id, p.dad_fname
           FROM class_registrations c
           JOIN students s
           ON s.id = c.student_id
           JOIN parents p
           ON p.id = s.parent_id
           WHERE c.classroom_id= " + params[:classroom_id].to_s
           records_array = ActiveRecord::Base.connection.exec_query(sql)  
           @userList = records_array      

        elsif selectedOption == 'Accepted'
           @userList = Parent.joins(:event_status).where("event_id =?", params[:eventId])
        
        else

           sql = "SELECT * 
                  FROM parents
                  JOIN event_statuses
                  ON parents.id = event_statuses.parent_id_declined
                  WHERE event_statuses.id = " + params[:eventId].to_s
           records_array = ActiveRecord::Base.connection.exec_query(sql)
           @userList = records_array
      end
      
      render json: @userList
    rescue Exception => e
      render json: e.message
    end
    
end

def create
	result = { status: "failed" }
	
	@event = Event.new
      @event.event_title = params[:event_title]
      @event.event_description = params[:event_description]
      @event.event_date = params[:event_date]
      @event.event_time = params[:event_time]
      @event.event_location = params[:event_location]
      @event.school_user_id = params[:user_id]
      @event.classroom_id = params[:classroom_id]
      
      if @event.save
        result[:status] = "success"
        render json: result.to_json
      else
        result[:status] = "Erros"
        render json: result.to_json
      end

      rescue Exception => e
	       Rails.logger.error "#{e.message}"
	       render json: e.message

      
end

def getEvents
	
end

private
	
  def event_params
      params.require(:event).permit(:event_title, :event_description, :event_time, :event_location, :school_users_id, :classroom_id)
    end		
  

  def set_access_control_headers
   headers['Access-Control-Allow-Origin'] = "http://localhost:8100"
   headers['Access-Control-Request-Method'] = %w{GET POST OPTIONS}.join(",")
  end

end