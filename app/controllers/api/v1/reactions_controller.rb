class Api::V1::ReactionsController < Api::ApiController
  def create
    @reaction = User.first.reactions.new(reaction_params)
    if @reaction.save
      render json: "reaction added"
    else
      render json: @reaction.errors
    end
  end

  def destroy
    @reaction = Reaction.find(params[:id])
    if @reaction.destroy
      render json: "reaction removed"
    else
      render json: { json: @reaction.errors }
    end
  end

  private

  def reaction_params
    params.require(:reaction).permit(:conversation_message_id, :emoji)
  end
end
