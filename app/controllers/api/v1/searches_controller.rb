class Api::V1::SearchesController < Api::ApiController
  def index
    query = params[:query]
    filter = params[:filter].eql?('null') ? nil : params[:filter]
    @results = SearchService.search_records(query, filter)
  end
end
