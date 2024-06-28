class KeyTypePicker
  def self.key_type
    if Gem.win_platform?
      :string
    else
      :uuid
    end
  end
end
