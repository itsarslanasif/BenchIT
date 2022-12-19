class Api::V1::ProfilesController < Api::ApiController
  before_action :set_workspace, only: %i[index create show]
  before_action :check_profile_already_exists, only: %i[create]

  def index
    @profiles = if params[:query].presence
                  Profile.search(
                    params[:query],
                    where: { workspace_id: @workspace.id },
                    match: :word_start, misspellings: false
                  )
                else
                  @workspace.profiles.all
                end
    @profiles = @profiles.reorder(username: :asc) if params[:sort] == 'asc'
    @profiles = @profiles.reorder(username: :desc) if params[:sort] == 'desc'
  end

  def show
    @profile = @workspace.profiles.find(params[:id])
  end

  def create
    @profile = current_user.profiles.new(profile_params)

    if @profile.save
      render json: "Profile Added to #{@workspace.company_name}"
    else
      render json: { errors: @profile.errors, message: 'There was an error creating the profile' }, status: :unprocessable_entity
    end
  end

  private

  def set_workspace
    @workspace = Workspace.find_by(id: params[:workspace_id])

    return render json: { message: 'Workspace Not Found.' }, status: :not_found if @workspace.nil?
  end

  def profile_params
    params.require(:profile).permit(:username, :description, :id).tap do |param|
      param[:workspace_id] = params[:workspace_id]
    end
  end

  def check_profile_already_exists
    return if current_user.profiles.find_by(workspace_id: params[:workspace_id]).nil?

    render json: { message: 'You already have a profile in this workspace.' }, status: :unprocessable_entity
  end
end
