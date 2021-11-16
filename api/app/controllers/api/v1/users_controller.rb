class Api::V1::UsersController < Api::V1::ApplicationController
  def show
    @user = User.find_by(uname: params[:id])
  end
end