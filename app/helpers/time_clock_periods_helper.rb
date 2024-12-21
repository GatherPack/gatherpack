module TimeClockPeriodsHelper
  def calculate_cumulative_hours(time_clock_periods, person)
    hours = []
    time_clock_periods.each do |period|
      hours << [ period.name, TimeClockPunch.where(time_clock_period: period, person: person).sum(:duration) ]
    end
    hours.sort_by { |period| period[1] }.reverse
  end

  def time_clock_period_as_badge(time_clock_period, opt = nil)
    content = i('hourglass-half') + ' ' + time_clock_period.identifier_name
    if opt.present? && opt
      link_to time_clock_period, class: 'undecorated', 'data-turbo': false do
        tag.span content, class: 'badge text-bg-primary'
      end
    else
      link_to time_clock_period, class: 'undecorated' do
        tag.span content, class: 'badge text-bg-primary'
      end
    end
  end
end
