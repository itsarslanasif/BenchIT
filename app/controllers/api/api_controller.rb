class Api::ApiController < ApplicationController
  # before_action :presence_of_access_token

  # private

  # def presence_of_access_token
  #   return if request.headers[:api_access_token].present? || request.headers[:HTTP_API_ACCESS_TOKEN].present?

  #   render json: {success: false, error: "You need to sign in before." }
  # end
end
