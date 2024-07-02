module ApplicationHelper
  def contrasting_color(color)
    base = Color::RGB.by_hex(color)
    if base.brightness > 0.5
      '#000'
    else
      '#fff'
    end
  end

  def as_badge(obj)
    case obj
    when Badge
      badge_as_badge(obj)
    when Team
      team_as_badge(obj)
    end.html_safe
  end

  def flash_to_class(type)
    case type
    when 'notice'
      bootstrap_type = 'info';
    else
      bootstrap_type = type;
    end

    "alert-" + bootstrap_type
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

    "fa-" + bootstrap_icon
  end
end
