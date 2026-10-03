class InternalController < ApplicationController
  before_action :check_for_user
  # Every action must authorize, and every index must scope, so a missing
  # check fails loudly instead of quietly allowing access. Checked by action
  # name rather than with only:/except:, since many controllers have no index.
  after_action :verify_pundit_authorization

  private

  def verify_pundit_authorization
    action_name == "index" ? verify_policy_scoped : verify_authorized
  end
end
