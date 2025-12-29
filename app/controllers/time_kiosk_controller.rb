class TimeKioskController < ApplicationController
  layout "kiosk"

  def index
    @time_kiosk = TimeKiosk.new(time_kiosk_params)
    @time_kiosk.tool ||= "welcome"

    if @time_kiosk.tool == "find_token"
      if @time_kiosk.token
        if @time_kiosk.token.tokenable.is_a?(Person)
          @person = @time_kiosk.token.tokenable
          @time_clocks = @person.time_clock_punches.order(time_clock_period_id: :asc).map do |punch|
            Hash[TimeClockPeriod.find_by_id(punch.time_clock_period_id), punch.hours]
          end.reduce do |a, b|
            a.merge(b) { |_, c, d| c + d }
          end
          @time_clock_periods = TimeClockPeriod.where(team: @person.all_teams).or(TimeClockPeriod.where(team: nil)).where("start_time <= ? AND end_time >= ?", Time.current, Time.current)
          @open_punches = TimeClockPunch.all.where(person: @person, end_time: nil)
          @time_clock_periods -= @open_punches.map(&:time_clock_period).compact.uniq
          @time_kiosk.tool = "found_person"
        elsif @time_kiosk.token.tokenable.is_a?(Hook)
          @hook = @time_kiosk.token.tokenable
          @time_kiosk.tool = "found_hook"
        else
          @time_kiosk.tool = "not_found"
        end
      else
        @time_kiosk.tool = "welcome"
      end
    end

    if @time_kiosk.tool == "punch_in"
      if @time_kiosk.time_clock_period
        period = @time_kiosk.time_clock_period
        TimeClockPunch.create(person: @time_kiosk.person, start_time: Time.current, time_clock_period: period, created_by: "kiosk")
      end
      @time_kiosk.tool = "welcome"
    end

    if @time_kiosk.tool == "punch_out"
      if @time_kiosk.time_clock_punch
        punch = @time_kiosk.time_clock_punch
        current_time = Time.current
        max_time = punch.time_clock_period&.end_time || current_time
        end_time = current_time > max_time ? max_time: current_time

        punch.update(end_time: end_time, created_by: "kiosk")
      end
      @time_kiosk.tool = "welcome"
    end

    if @time_kiosk.tool == "punch_out_period"
      if @time_kiosk.time_clock_period && @time_kiosk.person && Pundit.policy(@time_kiosk.person.user, @time_kiosk.time_clock_period).edit?
        period = @time_kiosk.time_clock_period
        current_time = Time.current
        max_time = period&.end_time || current_time
        end_time = current_time > max_time ? max_time: current_time

        period.open_punches.each do |punch|
          punch.update(end_time: end_time, created_by: "kiosk")
        end
      end
      @time_kiosk.tool = "welcome"
    end

    if @time_kiosk.tool == "punch_out_all"
      current_time = Time.current
      @time_kiosk.managed_periods.each do |period|
        max_time = period&.end_time || current_time
        end_time = current_time > max_time ? max_time: current_time
        period.open_punches.each do |punch|
          punch.update(end_time: end_time, created_by: "kiosk")
        end
      end
      @time_kiosk.tool = "welcome"
    end

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("kiosk-content", partial: "time_kiosk/kiosk") }
      format.html { render :index }
    end
  end

  private

  def time_kiosk_params
    params.require(:time_kiosk).permit(:tool, :token_value, :time_clock_period_id, :time_clock_punch_id, :person_id) if params[:time_kiosk]
  end
end
