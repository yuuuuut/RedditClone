class Api::V1::PostImagesController < Api::V1::ApplicationController
  before_action :authenticate_user!

  def destroy
    @post_image = PostImage.find_by(id: params[:id])
    @post_image.destroy!
  end
end