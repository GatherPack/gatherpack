# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # Throttles reset-email sends (enumeration and mail spam).
  rate_limit to: 10, within: 15.minutes, only: :create
end
