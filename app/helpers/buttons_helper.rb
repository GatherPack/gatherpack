module ButtonsHelper
  def tool_button(icon, key, klass, link, method: nil, **opts)
    data = {}
    data["turbo-method"] = method if method
    data.merge!(opts[:data] || {})
    link_to link, class: "btn-tool #{klass}", data: data, **opts do
      i(icon, size: "fa-2x") + key
    end
  end

  def tool_modal_button(icon, key, klass, target, **opts)
    data = { bs_toggle: "modal", bs_target: "##{target}" }
    data.merge(opts[:data] || {})
    link_to "#", class: "btn-tool #{klass}", data: data, **opts do
      i(icon, size: "fa-2x") + key
    end
  end
end
