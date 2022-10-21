class SwaggerController < ApplicationController
  def respond
    if Rails.env.development? || Rails.env.test?
      render inline: File.read(Rails.root.join('swagger', derived_path))
    else
      head :not_found
    end
  end

  private

  def derived_path
    params[:path] ||= 'index.html'
    path = params[:path]
    path << ".#{params[:format]}" unless path.ends_with?(params[:format].to_s)
    path
  end
end
