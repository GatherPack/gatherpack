class PersonActivityController < ApplicationController
  before_action :set_person

  def index
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
