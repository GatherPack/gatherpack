module FontAwesomeHelper
  def i(icon, family: nil, size: nil)
    if icon.is_a? Array
      family = icon[1]
      icon = icon[0]
    end
    family ||= "solid"
    klass = "fa-fw fa-#{family}"
    klass += " " + size if size
    klass += icon =~ /^fa-/ ? " " + icon : " fa-" + icon
    tag.i class: klass
  end

  def no_i(icon, family: nil, size: nil)
    outer_klass = "fa-stack"
    outer_klass += " " + size if size

    family ||= "solid"
    klass = "fa-stack-1x fa-#{family}"
    klass += " " + size if size
    klass += icon =~ /^fa-/ ? " " + icon : " fa-" + icon

    tag.span class: outer_klass do
      tag.i(class: klass) +
      tag.i(class: "fa-ban fa-solid fa-stack-1x", style: "color: red")
    end
  end

  def font_awesome_tag
    tag.script src: "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/js/all.min.js", data: { mutateApproach: "sync" }
  end

  def icon_text(icon, text, family: nil)
    (i(icon, family: family) + " " + text).html_safe
  end
end
