class Api::V1::MentionsController < Api::ApiController
  def channels_list
    @private_channels = BenchChannel.user_joined_private_channels(current_user.id)
    @public_channels = BenchChannel.public_channels.all
  end

  def users_list
    @users = User.all
  end
end
