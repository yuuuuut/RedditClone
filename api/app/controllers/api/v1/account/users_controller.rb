class Api::V1::Account::UsersController < Api::V1::ApplicationController
  before_action :authenticate_user!

  def update_uname
    current_user.update!(uname: User.processing_uname(update_uname_params[:uname]), is_first_login: false)
  end

  private
  def update_uname_params
    params.permit(:uname)
  end
end