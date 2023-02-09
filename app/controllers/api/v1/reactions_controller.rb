class Api::V1::ReactionsController < Api::ApiController
  include MemberShip

  before_action :verify_membership, only: %i[create]
  before_action :set_reaction, :authenticate_reaction, only: %i[destroy]

  def create
    @reaction.save!
    render json: { success: true, message: I18n.t('api.v1.reactions.create.success') }, status: :ok
  end

  def destroy
    @reaction.destroy!
    render json: { success: true, message: I18n.t('api.v1.reactions.destroy.success') }, status: :ok
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
      render json: { success: false, error: I18n.t('api.v1.reactions.authenticate_reaction.failure') }, status: :unauthorized
    end
  end

  def verify_membership
    @reaction = current_profile.reactions.find_or_create_by(reaction_params)
    check_membership(@reaction.bench_conversation)
  end
end
