module TokensHelper
  def token_as_badge(token)
    content = i('id-badge') + ' ' + token.pretty_value
    tag.span content, class: 'badge text-bg-dark'
  end
end
