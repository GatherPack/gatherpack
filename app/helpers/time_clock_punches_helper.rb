module TimeClockPunchesHelper
  def time_clock_punch_as_badge(punch)
    content = i("hourglass-half") + " #{punch.hours} hours - #{time_ago_in_words(punch.end_time || punch.start_time)} ago"
    tag.span content, class: "badge text-bg-primary"
  end
end
