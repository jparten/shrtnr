class Api::V1::UsersController < Api::BaseController
  include UsersHelper

  before_action :authenticate_with_api_key

  def show
    render json: @user.to_json(only: [:name, :email], 
                              include: {links: {only: [:short_url, :long_url, :clicks] } })
  end
end
