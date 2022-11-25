class Api::ProfilesController < Api::ApiController
  before_action :set_workspace, only: %i[index create]

  def index
    query = params[:query].present? ? params[:query] : nil
    @profiles = if query
      Profile.search( query, where: { workspace_id: @workspace.id }, match: :word_start, misspellings: false)
    else
      @workspace.profiles.all
    end
    @profiles = @profiles.reorder(username: :asc) if params[:sort] == 'asc'
    @profiles = @profiles.reorder(username: :desc) if params[:sort] == 'desc'
  end

  def create
    if current_user
      @profile = current_user.profiles.new(profile_params)
      if @profile.save
        render json: "Profile Added to #{@workspace.company_name}"
      else
        render json: @profile.errors
      end
    else
      render json: { message: 'user not logged in' }, status: :unauthorized
    end
  end

  private

  def set_workspace
    @workspace = Workspace.find_by(id: params[:workspace_id])
    return render json: { message: 'Workspace Not Found.' }, status: :not_found if @workspace.nil?
  end

  def profile_params
    params.require(:profile).permit(:workspace_id, :username, :description)
  end
end
