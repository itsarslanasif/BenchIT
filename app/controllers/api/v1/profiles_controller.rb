class Api::V1::ProfilesController < Api::ApiController
  before_action :set_profile, only: %i[show]
  skip_before_action :set_workspace_in_session, only: %i[create]
  before_action :set_workspace, only: %i[index create show update]
  before_action :check_profile_already_exists, only: %i[create]
  before_action :check_user_member_of_workspace, only: %i[show update]
  before_action :find_profile, only: %i[update set_status clear_status set_is_active remove_is_active]
  before_action :fetch_country_name, only: %i[update]

  def index
    @profiles = if params[:query].presence
                  Profile.search(
                    params[:query],
                    where: { workspace_id: @workspace.id },
                    match: :word_start, misspellings: false
                  )
                else
                  @workspace.profiles
                end
    @profiles = @profiles.reorder(username: :asc) if params[:sort] == 'asc'
    @profiles = @profiles.reorder(username: :desc) if params[:sort] == 'desc'
  end

  def show; end

  def create
    @profile = current_user.profiles.new(profile_params)
    @profile.save!
    render json: { success: true, message: t('.create.success') }, status: :ok
  end

  def update
    current_profile.update!(profile_params)
    @profile = current_profile
  end

  def set_status
    @profile.update!(profile_params)
    set_job
  end

  def set_is_active
    @profile.update!(is_active: true)
    render json: { success: true, message: t('.set_is_active.success') }, status: :ok
  end

  def remove_is_active
    @profile.update!(is_active: false)
    render json: { success: true, message: t('.remove_is_active.success') }, status: :ok
  end

  def clear_status
    @profile.update!(text_status: '', emoji_status: '', clear_status_after: '')
    render json: { success: true, message: t('.clear_status.success') }, status: :ok
  end

  private

  def set_job
    if params[:clear_status_after].eql?("don't clear")
      @profile.statuses.create(profile_params)
    else
      @profile.statuses.create(text: params[:text_status],
                               emoji: params[:emoji_status], clear_after: params[:clear_status_after].to_time - DateTime.now)
      ClearStatusJob.set(wait_until: params[:clear_status_after].to_time).perform_later(@profile.id)
    end
  end

  def find_profile
    @profile = Profile.find(params[:id])
  end

  def set_workspace
    @workspace = Workspace.find(params[:workspace_id])
  end

  def profile_params
    params.permit(:username, :description, :recording, :profile_image, :role, :display_name, :title, :text_status, :emoji_status,
                  :clear_status_after, :time_zone, :pronounce_name, :phone, :skype).tap do |param|
      param[:workspace_id] = params[:workspace_id]
    end
  end

  def fetch_country_name
    params[:time_zone] = params[:time_zone].split[1..].join(' ') if params[:time_zone].present?
  end

  def check_user_member_of_workspace
    return if current_workspace.id.eql?(params[:workspace_id].to_i)

    render json: { success: false, error: t('.check_user_member_of_workspace.success') }, status: :unauthorized
  end

  def check_profile_already_exists
    return if current_user.profiles.find_by(workspace_id: params[:workspace_id]).nil?

    render json: { success: false, error: t('.check_profile_already_exists.success') }, status: :unprocessable_entity
  end

  def set_profile
    @profile = Profile.find(params[:id])
  end
end
