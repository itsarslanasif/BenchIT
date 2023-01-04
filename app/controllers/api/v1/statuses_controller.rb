class Api::V1::StatusesController < Api::ApiController
  before_action :set_status, only: :destroy

  def index
    @recent_statuses = Current.profile.recent_statuses.last(4)
    @workspace_statuses = Current.workspace.workspace_statuses
  end

  def create
    @profile_status = Current.profile.build_profile_status(status_params)
    @recent_status = Current.profile.recent_statuses.new(status_params)

    if @profile_status.save
      @recent_status.update(clear_after: params[:clear_after].to_time - DateTime.now)
      ClearStatusJob.set(wait_until: params[:clear_after].to_time).perform_later(@profile_status.id)
      render json: @profile_status, status: :ok
    else
      render json: @profile_status.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @status.destroy
      render json: 'Status cleared', status: :ok
    else
      render json: @status.errors, status: :unprocessable_entity
    end
  end

  private

  def set_status
    @status = Status.find(params[:id])

    return render json: { message: 'Status Not Found.' }, status: :not_found if @status.nil?
  end

  def status_params
    params.require(:status).permit(:text, :emoji, :clear_after)
  end
end
