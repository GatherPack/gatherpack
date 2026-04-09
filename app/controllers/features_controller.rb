class FeaturesController < ApplicationController
  before_action :check_for_architect

  def index
    @features = GatherPack::Features.all.select(&:toggleable?)
  end

  def update
    # Iterate all toggleable features so that unchecked boxes (which send no
    # param) are explicitly set to false rather than silently skipped.
    GatherPack::Features.all.select(&:toggleable?).each do |feature|
      submitted = params.dig(:features, feature.key.to_s) == "true"
      Settings.set(feature.setting_key, submitted.to_s)
    end
    redirect_to features_path,
      notice: "Features updated. A server restart is required for route changes to take effect.",
      status: :see_other
  end
end
