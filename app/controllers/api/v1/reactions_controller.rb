class Api::V1::ReactionsController < Api::ApiController
  include MemberShip

  before_action :verify_membership, only: %i[create]
  before_action :set_reaction, :authenticate_reaction, only: %i[destroy]

  def create
    @reaction.save!
    render json: { success: true, message: 'Reaction added successfully.' }, status: :ok
  end

  def destroy
    @reaction.destroy!
    render json: { success: true, message: 'reaction removed' }, status: :ok
  end

  private

  def set_reaction
    @reaction = Reaction.find(params[:id])
  end

  def reaction_params
    params.require(:reaction).permit(:conversation_message_id, :emoji)
  end

  def authenticate_reaction
    if @reaction.profile_id.eql?(current_profile.id)
      check_membership(@reaction.bench_conversation)
    else
      render json: { error: 'Sorry, this reaction is not yours' }, status: :unauthorized
    end
  end

  def verify_membership
    @reaction = current_profile.reactions.find_or_create_by(reaction_params)
    check_membership(@reaction.bench_conversation)
  end
end
