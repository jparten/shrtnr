class Api::BaseController < ApplicationController

  def authenticate_with_api_key
    api_key = request.headers["Authorization"] || params[:api_key]
    if @user = User.find_by_api_key(api_key)
      @user
    else
      render nothing: true, status: :unauthorized
    end
  end

end
