class InternalController < ApplicationController
  include Pundit::Authorization
  before_action :check_for_user
end
