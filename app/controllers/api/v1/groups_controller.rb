class Api::V1::GroupsController < Api::ApiController
  before_action :set_group, only: %i[show add_member]
  before_action :group_size, only: %i[add_member]
  before_action :check_group_members, only: %i[add_member]

  def index
    render json: Current.profile.groups
  end

  def show
    @profiles = Profile.where(id: @group.profile_ids)
  end

  def add_member
    @group.profile_ids += params[:profile_ids]
    if @group.save
      render json: { message: 'Members are added successfully.' }, status: :ok
    else
      render json: { error: 'Unable to add members', errors: @group.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_group
    @group = Group.find(params[:id])
    render json: { error: 'User is not part of this group' }, status: :not_found unless @group.profile_ids.include?(Current.profile.id)
  end

  def group_size
    render json: { error: 'Max group size is 9' }, status: :bad_request if (@group.profile_ids.size + params[:profile_ids].size) > 9
  end

  def check_group_members
    return unless (@group.profile_ids & params[:profile_ids]).any?

    render json: { error: 'One or Many Users already member of this group' }, status: :unprocessable_entity
  end
end
