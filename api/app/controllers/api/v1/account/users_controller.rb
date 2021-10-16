class Api::V1::Account::UsersController < Api::V1::ApplicationController
  before_action :authenticate_user!

  def update_uname
    is_uname_user = User.find_by(uname: update_uname_params[:uname])
    raise 'このIDは既に使用されています。' unless !is_uname_user
    current_user.update!(uname: update_uname_params[:uname], is_first_login: false)
  end

  private
  def update_uname_params
    params.permit(:uname)
  end
end