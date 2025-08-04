class PersonActivityController < ApplicationController
  before_action :set_person

  def index
    @upcoming_events = policy_scope(@person.events).where("start_time > ?", Time.current)
    @recent_punches = policy_scope(@person.time_clock_punches).order(start_time: :desc).first(10)
    @recent_notes = policy_scope(@person.calendar_notes).order(start_time: :desc).first(3)
  end

  def time_clock_punches
  end

  def events
  end

  private

  def set_person
    @person = policy_scope(Person).find(params[:id])
  end
end
