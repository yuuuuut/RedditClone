class Api::V1::CommunitiesController < Api::V1::ApplicationController
  def index
    @communities = Community.limit(4)
  end

  def show
    @community = Community.find_by(name: params[:id])
  end
end