class CalendarController < ApplicationController
  def index
  end

  def calendar
    respond_to do |format|
      format.html { redirect_to calendar_index_path }
      format.json do
        start_time = params[:start_time]
        end_time = params[:end_time]

        if params[:events]
          ransacked_events = policy_scope(Event).ransack(params[:q]).result(distinct: true)
          ransacked_events = ransacked_events.joins(:checkins).where(checkins: { person_id: params[:person_id] }) if params[:person_id]
          @events = ransacked_events.where("start_time >= ? AND start_time <= ?", start_time, end_time)
            .or(ransacked_events.where("start_time <= ? AND end_time >= ?", start_time, start_time))
        end

        if params[:birthdays]
          @start_time_doy = Date.parse(start_time).yday
          @end_time_doy = Date.parse(end_time).yday
          @start_time_year = Date.parse(start_time).year
          @end_time_year = Date.parse(end_time).year

          ransacked_people = policy_scope(Person).ransack(
            display_name_i_cont: params[:q][:name_i_cont]
          ).result(distinct: true)
          ransacked_people = ransacked_people.joins(:memberships).where(memberships: { person_id: (Team.find(params[:q][:team_id_eq]).all_people) }).uniq if params[:q][:team_id_eq].present?
          ransacked_people = ransacked_people.where(id: params[:person_id]) if params[:person_id]
          @birthdays = ransacked_people.where("DATE_PART('doy', birthday) >= ? AND DATE_PART('doy', birthday) <= ? AND DATE_PART('year', birthday) <= ?", @start_time_doy >= @end_time_doy ? 0 : @start_time_doy, @end_time_doy, @start_time_year)
            .or(ransacked_people.where("DATE_PART('doy', birthday) >= ? AND DATE_PART('doy', birthday) <= ? AND DATE_PART('year', birthday) <= ?", @start_time_doy >= @end_time_doy ? @start_time_doy : 367, 366, @start_time_year))
        end

        if params[:notes]
          ransacked_notes = policy_scope(CalendarNote).ransack(params[:q]).result(distinct: true)
          ransacked_notes = ransacked_notes.where(noteable: params[:person_id]) if params[:person_id]
          @notes = ransacked_notes.where("start_time >= ? AND start_time <= ?", start_time, end_time)
            .or(ransacked_notes.where("start_time <= ? AND end_time >= ?", start_time, start_time))
        end
      end
    end
  end
end
