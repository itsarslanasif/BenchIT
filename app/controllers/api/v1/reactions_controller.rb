class Api::V1::ReactionsController < Api::ApiController
  before_action :initialize_reaction, only: %i[create]
  before_action :set_reaction, only: %i[destroy]
  before_action :authenticate_reaction, only: %i[create destroy]

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
  end

  def reaction_params
    params.require(:reaction).permit(:conversation_message_id, :emoji)
  end

  def initialize_reaction
    @reaction = current_profile.reactions.new(reaction_params)
  end

  def authenticate_reaction
    case action_name
    when 'create'
      authorize! :create, @reaction
    when 'destroy'
      authorize! :destroy, @reaction
    end
  end
end
