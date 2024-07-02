module PeopleHelper
  def get_avatar_url(avatar)
    avatar.attached? ? url_for(avatar) : "https://http.cat/404.jpeg"
  end
end
