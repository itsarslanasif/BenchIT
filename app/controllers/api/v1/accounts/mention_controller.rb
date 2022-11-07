class Api::V1::Accounts::MentionController < Api::V1::Accounts::BaseController
  def get_channels_list
    @private_channels = BenchChannel.user_joined_private_channels(current_user.id)
    @public_channels = BenchChannel.public_channels.all
  end

  def get_users_list
    @users = User.all
  end
end
