class InternalController < ApplicationController
  before_action :check_for_user
  # Every action must authorize, and every index must scope, so a missing
  # check fails loudly instead of quietly allowing access.
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index
end
