class Api::V1::GroupsController < Api::ApiController
  include CanAuthorization

  before_action :set_group, :authenticate_group, only: %i[show add_member]
  before_action :group_size, :check_group_members, only: %i[add_member]

  def index
    render json: current_profile.groups
  end

  def show
    @profiles = Profile.where(id: @group.profile_ids)
  end

  def create
    @group = Group.create!(profile_ids: params[:profile_ids])
  end

  def add_member
    @group.profile_ids += params[:profile_ids]
    @group.save!
    render json: { success: true, message: t('.success') }, status: :ok
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

  def check_group_members
    return unless (@group.profile_ids & params[:profile_ids]).any?

    render json: { success: false, error: t('.failure') }, status: :unprocessable_entity
  end
end
