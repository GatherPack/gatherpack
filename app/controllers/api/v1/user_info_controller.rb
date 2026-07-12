class Api::V1::UserInfoController < ApplicationController
  before_action :doorkeeper_authorize!
  skip_before_action :check_for_user

  def show
    user = User.find(doorkeeper_token.resource_owner_id)
    render json: user_info_payload(user)
  end

  private

  def user_info_payload(user)
    payload = { sub: user.neat_id }

    scopes = doorkeeper_token.scopes

    if scopes.exists?(:user_email)
      payload[:email] = user.email
      payload[:email_verified] = true
    end

    if scopes.exists?(:user_name) && user.person
      payload[:name] = user.person.display_name
      payload[:preferred_username] = user.person.display_name
      payload[:given_name] = user.person.first_name
      payload[:family_name] = user.person.last_name
      payload[:profile] = person_url(user.person)
      payload[:picture] = url_for(user.person.avatar) if user.person.avatar.attached?
    end

    if scopes.exists?(:teams_read) && user.person
      payload[:teams] = user.person.teams.pluck(:name)
    end

    if scopes.exists?(:badges_read) && user.person && GatherPack::Features.enabled?(:badges)
      payload[:badges] = user.person.badges.pluck(:name)
    end

    if user.person
      payload[:roles] = user.person.roles
    end

    payload
  end
end
