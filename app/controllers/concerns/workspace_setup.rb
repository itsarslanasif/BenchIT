module WorkspaceSetup
  extend ActiveSupport::Concern

  def initialize_workspace(workspace)
    @workspace = workspace
    create_profile
    create_workspace_data
    WorkspaceMailer.send_workspace_creation_mail(@workspace, @profile, current_user).deliver_now
  end

  def create_profile
    user = Current.user
    @profile = @workspace.profiles.create!(username: user.name, role: 0, user_id: user.id)
    Current.profile = @profile
  end

  def create_workspace_data
    ActiveRecord::Base.transaction do
      new_channel = BenchChannel.create!(name: 'general', description: 'general')
      BenchConversation.create!(conversationable: new_channel)
      new_channel.channel_participants.create!(profile_id: @profile.id, role: :channel_manager)
    end
  end
end
