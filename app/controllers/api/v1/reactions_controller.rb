class Api::V1::ReactionsController < Api::ApiController
  before_action :set_reaction, only: :destroy

  def create
    @reaction = Current.profile.reactions.new(reaction_params)

    if @reaction.save
      render json: @reaction, status: :ok
    else
      render json: @reaction.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @reaction.destroy
      render json: 'reaction removed', status: :ok
    else
      render json: @reaction.errors, status: :unprocessable_entity
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
