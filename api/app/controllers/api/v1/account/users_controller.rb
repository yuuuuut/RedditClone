class Api::V1::Account::UsersController < Api::V1::ApplicationController
  before_action :authenticate_user!

  include Pagination

  def show
    @user = User.find_by(uname: params[:id], uname: current_user.uname)
    @posts = Post.sort(params[:sort]).post_includes.where(user: @user).page(params[:page]).per(10)
    @pagination = resources_with_pagination(@posts)
  end

  def update_uname
    current_user.update!(uname: User.processing_uname(update_uname_params[:uname]), is_first_login: false)
  end

  private
  def update_uname_params
    params.permit(:uname)
  end
end