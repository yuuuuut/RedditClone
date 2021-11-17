class Api::V1::CommunitiesController < Api::V1::ApplicationController
  include Pagination

  def index
    @communities = Community.limit(4)
  end

  def show
    @community = Community.find_by(name: params[:id])
    @posts = Post.sort(params[:sort]).post_includes.where(community: @community).page(params[:page]).per(10)
    @pagination = resources_with_pagination(@posts)
  end
end