module TokensHelper
  def token_as_badge(token)
    content = token.pretty_value
    tag.span content, class: 'badge text-bg-dark'
  end
end
