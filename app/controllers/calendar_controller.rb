class CalendarController < ApplicationController
  def index
  end

  def calendar
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json do
        start_time = params[:start_time]
        end_time = params[:end_time]
        start_time_doy = Date.parse(start_time).yday
        end_time_doy = Date.parse(end_time).yday
        start_time_year = Date.parse(start_time).year
        end_time_year = Date.parse(end_time).year

        render json: Jbuilder.new { |json|
          if params[:events]
            ransacked_events = policy_scope(Event).ransack(params[:q]).result(distinct: true)
            events = ransacked_events.where("start_time >= ? AND start_time <= ?", start_time, end_time)
              .or(ransacked_events.where("start_time <= ? AND end_time >= ?", start_time, start_time))
            json.array! events do |event|
              background_color = event.team&.color || "#3788d8"
              json.id event.id
              json.title event.name
              json.allDay false
              json.start event.start_time
              json.end event.end_time
              json.url event_url(event)
              json.backgroundColor background_color
              json.textColor Color::RGB.by_hex(background_color).brightness > 0.5 ? "#6d6753" : "#fffdf6"

              json.extendedProps do
                json.icon "fa-" + (event.team&.team_type&.icon || "star")
              end
            end
          end

          if params[:birthdays]
            ransacked_people = policy_scope(Person).ransack(
              display_name_i_cont: params[:q][:name_i_cont]
            ).result(distinct: true)
            ransacked_people.joins(:memberships).where(memberships: { team_id: params[:q][:team_id_eq] }) if params[:q][:team_id_eq].present?
            birthdays = ransacked_people.where("DATE_PART('doy', birthday) >= ? AND DATE_PART('doy', birthday) <= ? AND DATE_PART('year', birthday) <= ?", start_time_doy >= end_time_doy ? 0 : start_time_doy, end_time_doy, start_time_year)
              .or(ransacked_people.where("DATE_PART('doy', birthday) >= ? AND DATE_PART('doy', birthday) <= ? AND DATE_PART('year', birthday) <= ?", start_time_doy >= end_time_doy ? start_time_doy : 367, 366, start_time_year))
            json.array! birthdays do |person|
              json.id person.id
              json.title "#{person.identifier_name}'s Birthday"
              json.allDay true
              json.start person.birthday.change(year: (person.birthday.yday - start_time_doy < 0 ? end_time_year : start_time_year))
              json.end nil
              json.url person_url(person)
              json.backgroundColor "#3788d8"
              json.textColor "#fffdf6"

              json.extendedProps do
                json.icon "fa-cake-candles"
              end
            end
          end

          if params[:notes]
            ransacked_notes = policy_scope(CalendarNote).ransack(params[:q]).result(distinct: true)
            notes = ransacked_notes.where("start_time >= ? AND start_time <= ?", start_time, end_time)
              .or(ransacked_notes.where("start_time <= ? AND end_time >= ?", start_time, start_time))
            json.array! notes do |note|
              json.id note.id
              json.title note.identifier_name + if note.noteable then " - " + note.noteable.identifier_name else "" end
              json.allDay note.end_time.nil?
              json.start note.start_time
              json.end note.end_time
              json.url calendar_note_url(note)
              json.backgroundColor "#efad03"
              json.textColor "#6d6753"

              json.extendedProps do
                json.icon "fa-note-sticky"
              end
            end
          end
        }.target!
      end
    end
  end
end
