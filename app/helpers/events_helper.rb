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

  def event_as_badge(event)
    content = i("calendar") + " #{event.identifier_name} (#{event.start_time})"
    content +=" - #{event.team.name}" if event.team
    link_to event, class: "undecorated" do
      tag.span content, class: "badge", style: "background-color: #{event.team&.color || "#0dcaf0"};"
    end
  end
end
