class Api::V1::AccountController < Api::V1::ApplicationController
  before_action :authenticate_user!

  def me
  end
end