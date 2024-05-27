module NavHelper
  def nav_link(link, path, icon, method: 'get')
    data = {}
    if method != 'get'
      data['turbo-method'] = method
    end
    tag.div class: 'nav-item' do
      if (path == '/' && request.path == '/') || (path != '/' && request.path.starts_with?(path))
        link_to path, class: 'active', data: data do
          icon_text(icon, link)
        end
      else
        link_to path, data: data do
          icon_text(icon, link)
        end
      end
    end
  end

  def nav_heading(label)
    tag.h6 label, class: 'nav-item'
  end
end
