class Api::V1::SavedItemsController < Api::ApiController
  include Pagination

  before_action :set_saved_item, only: %i[destroy]

  def index
    @pagy, @saved_items = pagination_for_save_messages(params[:page])
  end

  def create
    @saved_item = current_profile.saved_items.new(conversation_message_id: params[:conversation_message_id])
    @saved_item.save!
  end

  def destroy
    @saved_item.destroy!
    render json: { success: true, message: t('.success') }, status: :ok
  end

  private

  def set_saved_item
    @saved_item = current_profile.saved_items.find_by!(conversation_message_id: params[:id])
    authorize! :destroy, @saved_item
  end
end
