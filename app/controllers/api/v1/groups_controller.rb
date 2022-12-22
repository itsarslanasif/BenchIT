class Api::V1::GroupsController < Api::ApiController
  before_action :set_group, only: %i[show]

  def index
    render json: Current.profile.groups
  end

  def show; end

  private

  def set_group
    @group = Group.find(params[:id])
    render json: { message: 'User is not part of this group', status: :not_found } unless @group.profile_ids.include?(Current.profile.id)
  end
end
