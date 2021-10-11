class Api::V1::ApplicationController < ApplicationController
  include DeviseTokenAuth::Concerns::SetUserByToken

  before_action :skip_session
  helper_method :current_user

  def authenticate_user!
    authenticate_api_v1_user!
  end

  def current_user
    current_api_v1_user
  end

  protected

  def skip_session
    request.session_options[:skip] = true
  end
end
