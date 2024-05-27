module FontAwesomeHelper
  def i(icon, family: nil, size: nil)
    family ||= 'solid'
    klass = "fa-fw fa-#{family}"
    if size
      klass += ' ' + size
    end
    klass += ' fa-' + icon
    tag.i class: klass
  end

  def font_awesome_tag
    tag.script src: 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/js/all.min.js', data: { mutateApproach: 'sync' }
  end

  def icon_text(icon, text, family: nil)
    (i(icon, family: family) + ' ' + text).html_safe
  end
end
