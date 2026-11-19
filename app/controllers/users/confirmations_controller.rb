# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # Throttles confirmation-email resends (mail spam).
  rate_limit to: 10, within: 15.minutes, only: :create
end
