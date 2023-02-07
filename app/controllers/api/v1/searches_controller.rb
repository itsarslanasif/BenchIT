class Api::V1::SearchesController < Api::ApiController
  def index
    @results = SearchService.new(params[:query], params[:filter]).call
  end
end
