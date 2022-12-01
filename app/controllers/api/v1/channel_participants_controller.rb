class Api::V1::ChannelParticipantsController < Api::ApiController
  before_action :check_channel_participants, only: %i[create]
  def create
    @channel_participant_users=ChannelParticipant.where(user_id:@users_list_provided,bench_channel_id: @channel_id).pluck(:id)
    if @channel_participant_users.empty?
      @users_list_provided.map {|user|ChannelParticipant.new(bench_channel_id: @channel_id[0], user_id: user,permission: true).save}
      users_emails_joined=User.where(id: @users_list_provided).pluck(:email)
      return render status: 201, json: {new_member_added: users_emails_joined ,status_code: 2}
    else
      render json: {message: "One or Many Users already participant of this channel",status_code: 1, status: :unprocessable_entity }
    end
  end

  private
  def channel_participant_params
    params.permit(:bench_channel_name,:user_emails)
  end
  def check_channel_participants
    @channel_id = BenchChannel.where(name: params[:bench_channel_name]).pluck(:id)
    if @channel_id.empty?
      render json: {message: "channel not found",status_code: 1, status: :unprocessable_entity }
    else
      @users_list_provided=User.where(email: params[:user_emails]).pluck(:id)
      if @users_list_provided.empty?
        render json: {message: "No User Found or Wrong Emails Provided",status_code: 1, status: :unprocessable_entity }
      end
    end
  end
end
