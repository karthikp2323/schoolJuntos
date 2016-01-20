json.array!(@events) do |event|
  json.extract! event, :id, :event_title, :event_description, :event_time, :event_location, :school_users_id, :classroom_id
  json.url event_url(event, format: :json)
end
