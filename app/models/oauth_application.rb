class OauthApplication < Doorkeeper::Application
  has_neat_id :oap

  def identifier_name
    name
  end

  def selected_scopes
    scopes.presence&.split(/\s+/) || [] if scopes.is_a?(String)
  end

  def selected_scopes=(names)
    self.scopes = Array(names).reject(&:blank?).join(" ")
  end
end
