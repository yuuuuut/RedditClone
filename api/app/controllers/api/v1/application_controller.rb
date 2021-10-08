class Api::V1::ApplicationController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  #protect_from_forgery
  helper_method :current_user

  def authenticate_user!
    authenticate_api_v1_user!
  end

  def current_user
    current_api_v1_user
  end
end
