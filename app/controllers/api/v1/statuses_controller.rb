class Api::V1::StatusesController < Api::ApiController
  before_action :set_status, only: :destroy

  def index
    @recent_statuses = Current.profile.recent_statuses.last(4)
    @workspace_statuses = Current.workspace.workspace_statuses
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
  end

  def status_params
    params.require(:status).permit(:text, :emoji, :clear_after)
  end
end
