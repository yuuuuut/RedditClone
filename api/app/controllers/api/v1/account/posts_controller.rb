class Api::V1::Account::PostsController < Api::V1::ApplicationController
  before_action :authenticate_user!

  def index
    param = params[:status]
    if param
      @posts = Post.where(user: current_user, status: param).limit(10)
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
  end

  def update
    @post = Post.find_by(id: params[:id], user: current_user)
    ActiveRecord::Base.transaction do
      @post.update!(update_post_params)
      @post.create_community_if_exists(params[:community_id])
      @post.update_post_image(post_image_params[:url], post_image_params[:uid])
    end
  end

  private
  def update_post_params
    params.require(:post).permit(
      :title,
      :text,
      :url,
      :spoiler,
      :nsfw,
      :status,
      :type
    ).merge(user: current_user)
  end

  def post_image_params
    params.require(:post_image).permit(
      :uid,
      :url
    )
  end
end