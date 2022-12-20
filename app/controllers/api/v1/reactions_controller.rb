class Api::V1::ReactionsController < Api::ApiController
  before_action :set_reaction, only: :destroy

  def create
    @reaction = current_profile.reactions.new(reaction_params)

    if @reaction.save
      render json: 'Reaction added.'
    else
      render json: @reaction.errors
    end
  end

  def destroy
    if @reaction.destroy
      render json: 'Reaction removed.'
    else
      render json: { json: @reaction.errors }
    end
  end

  private

  def set_reaction
    @reaction = Reaction.find(params[:id])
  end

  def reaction_params
    params.require(:reaction).permit(:conversation_message_id, :emoji)
  end
end
