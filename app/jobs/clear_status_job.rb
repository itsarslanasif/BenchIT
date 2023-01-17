class ClearStatusJob < ApplicationJob
  queue_as :default

  def perform(profile_id)
    profile = Profile.find(profile_id)
    Current.profile = profile
    Current.workspace = profile.workspace
    profile.update_profile('', '', '')
  end
end
