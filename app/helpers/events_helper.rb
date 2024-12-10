module EventsHelper
  def format_event_time_date(event, format_type, include_location)
    parts = [
      event.start_time.to_fs(format_type), 
      event.end_time == nil ? "" : 
        " - " + event.end_time.to_fs(format_type)
    ]
    if include_location && event.location.present?
      parts << " at " + event.location
    end
    
    parts.join
  end
end
