class Api::V1::PreferencesController < Api::ApiController
  def update
    current_profile.preference.update!(preferences_params)
    render json: { success: true, message: t('.success') }, status: :ok
  end

  private

  def preferences_params
    params.require(:preference).permit(:messages_and_media)
  end
end
