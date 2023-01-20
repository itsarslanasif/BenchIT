class Api::V1::ReactionsController < Api::ApiController
  include MemberShip

  before_action :verify_membership, only: %i[create]
  before_action :set_reaction, :authenticate_reaction, only: %i[destroy]

  def create
    if @reaction.save
      render json: { message: 'Reaction added successfully.' }, status: :ok
    else
      render json: { error: 'Unable to add reaction.', errors: @reaction.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @reaction.destroy
      render json: { message: 'reaction removed' }, status: :ok
    else
      render json: { error: 'Unable to remove reaction.', errors: @reaction.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_reaction
    @reaction = Reaction.find(params[:id])
  end

  def reaction_params
    params.require(:reaction).permit(:conversation_message_id, :emoji)
  end

  def authenticate_reaction
    if @reaction.profile_id.eql?(Current.profile.id)
      check_membership(@reaction.bench_conversation)
    else
      render json: { error: 'Sorry, this reaction is not yours' }, status: :unauthorized
    end
  end

  def verify_membership
    @reaction = Current.profile.reactions.find_or_create_by(reaction_params)
    check_membership(@reaction.bench_conversation)
  end
end
