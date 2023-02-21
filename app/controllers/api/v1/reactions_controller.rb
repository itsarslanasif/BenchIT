class Api::V1::ReactionsController < Api::ApiController
  before_action :verify_reaction, only: %i[create]
  before_action :set_reaction, only: %i[destroy]

  def create
    @reaction.save!
    render json: { success: true, message: t('.create.success') }, status: :ok
  end

  def destroy
    @reaction.destroy!
    render json: { success: true, message: t('.destroy.success') }, status: :ok
  end

  private

  def set_reaction
    @reaction = Reaction.find(params[:id])
    authorize! :destroy, @reaction
  end

  def reaction_params
    params.require(:reaction).permit(:conversation_message_id, :emoji)
  end

  def verify_reaction
    @reaction = current_profile.reactions.new(reaction_params)
    authorize! :create, @reaction
  end
end
