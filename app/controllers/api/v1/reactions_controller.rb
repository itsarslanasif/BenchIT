class Api::V1::ReactionsController < Api::ApiController
  before_action :set_reaction, only: :destroy

  def create
    @reaction = current_user.reactions.new(reaction_params)

    render json: @reaction.save ? @reaction : @reaction.errors
  end

  def destroy
    render json: @reaction.destroy ? { json: 'Reaction removed' } : @reaction.errors
  end

  private

  def set_reaction
    @reaction = Reaction.find(params[:id])
  end

  def reaction_params
    params.require(:reaction).permit(:conversation_message_id, :emoji)
  end
end
