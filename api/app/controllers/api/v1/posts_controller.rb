class Api::V1::PostsController < Api::V1::ApplicationController
  before_action :authenticate_user!

  def index
    puts current_user
    @posts = [{ id: 1, title: 'Test1' }]
  end

  def create
    @post = Post.new
    @post.attributes = post_params
    @post.create_post_image(post_image_params[:url], post_image_params[:uid])
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