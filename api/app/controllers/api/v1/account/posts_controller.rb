class Api::V1::Account::PostsController < Api::V1::ApplicationController
  before_action :authenticate_user!

  def index
    param = params[:status]
    if param
      @posts = Post.where(user: current_user, status: param).limit(10)
    end
  end
end