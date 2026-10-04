# Signs a user in for system tests.
#
# Deliberately does NOT drive the Devise form: that view is gated behind
# Settings[:local_auth], which lives in a PStore file rather than the test
# database, so a UI login would pass or fail depending on local state. Warden's
# test mode injects the session directly and is independent of that setting.
module AuthenticationHelper
  include Warden::Test::Helpers

  def self.included(base)
    base.setup { Warden.test_mode! }
    base.teardown { Warden.test_reset! }
  end

  def sign_in_as(user)
    login_as(user, scope: :user)
  end
end
