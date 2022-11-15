class Api::GroupsController < Api::ApiController
  before_action :set_group, only: [:show]
  def index
    current_user = User.first
    @participants = current_user.user_groups.pluck(:group_id)
    @groups = Group.where(id:@participants)
    render json: @groups
  end

  private
  def set_group
    @group = Group.find_by_id(params[:id])
    return if @group.present?

    render json: { json: @group.errors, status: :unprocessable_entity }
  end
end
