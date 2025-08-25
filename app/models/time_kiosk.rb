class TimeKiosk
  include ActiveModel::Model

  attr_accessor :tool, :token_value, :time_clock_period_id, :time_clock_punch_id, :person_id

  def token
    @token ||= Token.find_by(value: token_value)
  end

  def time_clock_period
    @time_clock_period ||= TimeClockPeriod.find_by(id: time_clock_period_id)
  end

  def periods_for_token
    token&.person&.time_clock_periods
  end

  def time_clock_punch
    @time_clock_punch ||= TimeClockPunch.find_by(id: time_clock_punch_id)
  end

  def person
    @person ||= Person.find_by(id: person_id) || token&.tokenable
  end

  def managed_periods
    @managed_periods ||= person&.all_managed_teams&.map(&:time_clock_periods)&.flatten || []
  end
end
