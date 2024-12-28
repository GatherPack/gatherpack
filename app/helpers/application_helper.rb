module ApplicationHelper
  def contrasting_color(color)
    base = Color::RGB.by_hex(color)
    if base.brightness > 0.5
      '#000'
    else
      '#fff'
    end
  end

  def as_badge(obj, opt = nil)
    case obj
    when Badge
      badge_as_badge(obj)
    when Team
      team_as_badge(obj)
    when Token
      token_as_badge(obj)
    when Relationship
      relationship_as_badge(obj, opt)
    when Person
      person_as_badge(obj, opt)
    when Account
      account_as_badge(obj)
    when TimeClockPeriod
      time_clock_period_as_badge(obj, opt)
    end.html_safe
  end

  def flash_to_class(type)
    case type
    when 'notice'
      bootstrap_type = 'info'
    else
      bootstrap_type = type
    end

    'alert-' + bootstrap_type
  end

  def flash_to_icon(type)
    case type
    when 'success'
      bootstrap_icon = 'circle-check'
    when 'warning', 'danger'
      bootstrap_icon = 'triangle-exclamation'
    else
      bootstrap_icon = 'circle-info'
    end

    'fa-' + bootstrap_icon
  end

  def nice_date(t)
    t&.strftime('%B %-d, %Y')
  end

  def nice_datetime t
    t&.strftime('%B %-d, %Y at %-I:%M %p')
  end

  def nice_time(t)
    t&.strftime('%-I:%M %p')
  end

  def nice_datetime_range(a, b)
    if a.to_date === b.to_date
      "on #{nice_date a} from #{nice_time a} to #{nice_time b}"
    else
      "from #{nice_datetime a} to #{nice_datetime b}"
    end
  end
end
