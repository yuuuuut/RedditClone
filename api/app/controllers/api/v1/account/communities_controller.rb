class Api::V1::Account::CommunitiesController < Api::V1::ApplicationController
  before_action :authenticate_user!

  def create
    @community = Community.find_by(name: params[:community_id])
    current_user.join_community(@community)
  end

  def destroy
    community = Community.find_by(name: params[:id])
    current_user.leave_community(community)
  end
end