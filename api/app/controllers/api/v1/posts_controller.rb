class Api::V1::PostsController < Api::V1::ApplicationController
  before_action :authenticate_user!

  def index
    puts current_user
    @posts = [{ id: 1, title: 'Test1' }]
  end
end