class TimeKioskController < ApplicationController
  def index
    @accept_input = true
    @message = {}
    render layout: "kiosk"
  end

  def create
    if params[:time_clock_periods]
      person_punch_in
    else
      kiosk_punch_in
    end

    render :index, layout: "kiosk"
  end

  def kiosk_punch_in
    @token = Token.find_by_rfid(time_kiosk_params[:token_id])
    @accept_input = true
    @message = {}

    unless @token
      @message[:danger] = "Invalid Token"
    end

    case @token&.tokenable_type
    when "Hook"
      @hook = Hook.find(@token.tokenable_id)
      @message[:info] = @hook.run(@hook.code)
    when "Person"
      @person = Person.find(@token.tokenable_id)

      current_punches = TimeClockPunch.all.where(person: @person, end_time: nil)
      current_punches.each do |punch|
        # punch out people even if the TimeClockPeriod ended
        current_time = Time.current
        max_time = punch.time_clock_period&.end_time || current_time
        end_time = current_time > max_time ? max_time: current_time

        punch.created_by = "kiosk"
        punch.update(end_time: end_time)
        @message[:info] = "Punched out #{@person.identifier_name}."
      end

      if current_punches.empty?
        @time_clock_periods = TimeClockPeriod.where(team: @person.all_teams).or(TimeClockPeriod.where(team: nil)).where("start_time <= ? AND end_time >= ?", Time.current, Time.current)

        if @time_clock_periods.empty?
          TimeClockPunch.create(person: @person, start_time: Time.current, time_clock_period: nil)
          @message[:info] = "Punched in #{@person.identifier_name}."
        elsif @time_clock_periods.one?
          period = @time_clock_periods.first
          punch = TimeClockPunch.new(person: @person, start_time: Time.current, time_clock_period: period)
          punch.created_by = "kiosk"
          punch.save
          @message[:info] = "Punched in #{@person.identifier_name} for #{period.name}."
        else
          @accept_input = false
        end
      end
    end
  end

  def person_punch_in
    person = Person.find(time_clock_period_params[:person_id])
    period = TimeClockPeriod.find(time_clock_period_params[:time_clock_period_id])
    @message = {}

    punch = TimeClockPunch.new(person: person, start_time: Time.current, time_clock_period: period)
    punch.created_by = "kiosk"
    punch.save
    @accept_input = true
    @message[:info] = "Punched in #{person.identifier_name} for #{period.name}."
  end

  private

    def time_kiosk_params
      params.require(:time_kiosk).permit(:token_id)
    end

    def time_clock_period_params
      params.require(:time_clock_periods).permit(:person_id, :time_clock_period_id)
    end
end
