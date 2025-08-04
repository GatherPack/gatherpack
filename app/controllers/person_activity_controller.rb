class PersonActivityController < ApplicationController
  before_action :set_person

  def index
    @upcoming_events = policy_scope(@person.events).where("start_time > ?", Time.current)
    @recent_punches = policy_scope(@person.time_clock_punches).order(start_time: :desc).first(10)
    @recent_notes = policy_scope(@person.calendar_notes).order(start_time: :desc).first(3)
  end

  def time_clock_punches
    @time_clock_punches = policy_scope(@person.time_clock_punches).order(start_time: :desc, end_time: :desc).page(params[:page])
    @time_clock_punches.each do |punch|
      if policy(punch).edit?
        @has_editable_punches = true
        break
      end
    end
    @has_editable_punches ||= false
  end

  def events
  end

  private

  def set_person
    @person = policy_scope(Person).find(params[:id])
  end
end
