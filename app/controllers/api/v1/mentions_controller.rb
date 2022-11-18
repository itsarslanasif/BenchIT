class Api::V1::MentionsController < Api::ApiController
  def channels_list
    @private_channels = BenchChannel.user_joined_private_channels(current_user.id, session[:cuurent_workspace_id])
    @public_channels = BenchChannel.public_channels(session[:cuurent_workspace_id]).all
  end

  def users_list
    @users = User.workspace_users(session[:cuurent_workspace_id]).all
  end
end
