class ClearStatusJob < ApplicationJob
  queue_as :default

  def perform(profile_id)
    profile = Profile.find(profile_id)
    profile.update(text_status: "", emoji_status: "", clear_status_after: "")
  end
end
