class Api::V1::StatusesController < Api::ApiController
  before_action :set_status, only: :destroy

  def index
    @recent_statuses = Current.profile.statuses.last(4)
    @workspace_statuses = Current.workspace.statuses
  end

  def destroy
    @status.destroy!
    render json: { success: true, message: 'Status cleared' }, status: :ok
  end

  private

  def set_status
    @status = Status.find(params[:id])
  end

  def status_params
    params.require(:status).permit(:text, :emoji, :clear_after)
  end
end
