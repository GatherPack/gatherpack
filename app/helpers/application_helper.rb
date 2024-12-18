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
      person_as_badge(obj)
    when Account
      account_as_badge(obj)
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

  def nice_datetime(t)
    t&.strftime('%-I:%M %p %B %-d, %Y')
  end

  def nice_time(t)
    t&.strftime('%-I:%M %p')
  end

  def nice_datetime_range(a, b)
    if (b - a) < 24*60
      "#{nice_time a} to #{nice_time b}, #{nice_date b}"
    else
      "#{nice_datetime a} to #{nice_datetime b}"
    end
  end
end
