class Api::V1::GroupsController < Api::ApiController
  before_action :set_group, only: %i[show add_member]
  before_action :group_size, only: %i[add_member]
  before_action :check_group_members, only: %i[add_member]

  def index
    render json: current_profile.groups
  end

  def show
    @profiles = Profile.where(id: @group.profile_ids)
  end

  def add_member
    @group.profile_ids += params[:profile_ids]
    @group.save!
    render json: { success: true, message: t('.add_meber.success') }, status: :ok
  end

  private

  def set_group
    @group = Group.find(params[:id])
    return if @group.profile_ids.include?(current_profile.id)

    render json: { success: false, error: t('.set_group.failure') },
           status: :not_found
  end

  def group_size
    return unless (@group.profile_ids.size + params[:profile_ids].size) > 9

    render json: { success: false, error: t('.group_size.failure') },
           status: :bad_request
  end

  def check_group_members
    return unless (@group.profile_ids & params[:profile_ids]).any?

    render json: { success: false, error: t('.check_group_members.failure') }, status: :unprocessable_entity
  end
end
