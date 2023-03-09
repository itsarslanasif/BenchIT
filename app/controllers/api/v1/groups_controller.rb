class Api::V1::GroupsController < Api::ApiController
  include CanAuthorization

  before_action :set_group, :authenticate_group, only: %i[show add_member]
  before_action :group_size, :check_group, only: %i[add_member]

  def index
    @groups = current_profile.groups
  end

  def show
    @profiles = Profile.where(id: @group.profile_ids)
  end

  def create
    ActiveRecord::Base.transaction do
      @group = Group.find_or_create_by!(profile_ids: params[:profile_ids].sort)
      BenchConversation.find_or_create_by!(conversationable: @group)
    end
    render json: { success: true, message: t('.success'), group: @group, name: @group.name }, status: :ok
  end

  def add_member
    if @existing_group.present?
      render json: { success: true, group: @existing_group }, status: :ok
    else
      @group.profile_ids += params[:profile_ids]
      @group.save!
      render json: { success: true, message: t('.success'), group: @group, name: @group.name }, status: :ok
    end
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def authenticate_group
    authorize_action(action_name, @group)
  end

  def group_size
    return unless (@group.profile_ids.size + params[:profile_ids].size) > 9

    render json: { success: false, error: t('.failure') }, status: :bad_request
  end

  def check_group
    profile_ids = @group.profile_ids + params[:profile_ids]
    @existing_group = Group.find_by(profile_ids: profile_ids.uniq.sort)
  end
end
