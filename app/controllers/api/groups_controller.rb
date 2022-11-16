class Api::GroupsController < Api::ApiController
  before_action :set_group, only: [:show]
  def index
    current_user = User.first
    render json: current_user.user_groups
  end

  private
  def set_group
    @group = Group.find_by_id(params[:id])
    return if @group.present?
    render json: { json: @group.errors, status: :unprocessable_entity }
  end
end
