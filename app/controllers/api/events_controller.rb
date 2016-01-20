class Api::EventsController < ApplicationController
after_action :set_access_control_headers
skip_before_action :verify_authenticity_token, only: [:create]



def getEvent
	
	#@invitedCount = 
	#@acceptedCount = ClassRegistration.joins(student: :parent).where("classroom_id =?", params[:classroom_id] ).count

	@events = Event.all
	render json: @events

end

def getEventForClass
	
	@events = Event.where("classroom_id = ?", params[:classroom_id])
	render json: @events

end

def getCountForEvents
	
	@count = Event.joins(:student, :parent)


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