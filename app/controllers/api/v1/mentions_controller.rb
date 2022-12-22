class Api::V1::MentionsController < Api::ApiController
  def channels_list
    @private_channels = BenchChannel.profile_joined_private_channels
    @public_channels = BenchChannel.public_channels
  end

  def profiles_list
    @profiles = Profile.workspace_profiles
  end
end
