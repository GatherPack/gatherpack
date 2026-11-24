# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # Generous enough for a whole team signing in behind one school NAT.
  rate_limit to: 30, within: 3.minutes, only: :create
end
