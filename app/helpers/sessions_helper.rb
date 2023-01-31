module SessionsHelper
  def sign_in_url
    "#{request.base_url}/sign_in"
  end
end
