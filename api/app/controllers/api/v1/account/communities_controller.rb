class Api::V1::Account::CommunitiesController < Api::V1::ApplicationController
  before_action :authenticate_user!

  def index
    @communities = current_user.communities
  end

  def create
    @community = Community.new
    @community.attributes = create_community_params
    ActiveRecord::Base.transaction do
      @community.save!
      @community.become_moderator(current_user)
      current_user.join_community(@community)
    end
  end

  def join
    @community = Community.find_by(name: params[:id])
    current_user.join_community(@community)
  end

  def leave
    community = Community.find_by(name: params[:id])
    current_user.leave_community(community)
  end

  private
  def create_community_params
    params.require(:community).permit(
      :name,
      :type
    )
  end
end