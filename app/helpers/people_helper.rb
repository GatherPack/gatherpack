module PeopleHelper
  def get_avatar_url(avatar)
    avatar.attached? ? url_for(avatar) : asset_path("default_profile.png")
  end
end
