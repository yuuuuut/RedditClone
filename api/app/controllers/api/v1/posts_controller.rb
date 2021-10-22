class Api::V1::PostsController < Api::V1::ApplicationController
  before_action :authenticate_user!

  def index
    puts current_user
    @posts = Post.all
  end

  def create
    @post = Post.new
    @post.attributes = post_params
    if post_image_params[:url].present? || post_image_params[:uid].present?
      @post.build_post_image(url: post_image_params[:url], uid: post_image_params[:uid])
    end
    @post.save!
  end

  private
  def post_params
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