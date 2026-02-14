module TimeClockPeriodsHelper
  def time_clock_period_as_badge(time_clock_period, **opts)
    content = i("hourglass-half") + " " + time_clock_period.identifier_name
    if opts[:link]
      link_to time_clock_period, class: "undecorated", 'data-turbo': false do
        tag.span content, class: "badge text-bg-primary"
      end
    else
      link_to time_clock_period, class: "undecorated" do
        tag.span content, class: "badge text-bg-primary"
      end
    end
  end
end
