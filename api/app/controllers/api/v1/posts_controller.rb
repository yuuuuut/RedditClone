class Api::V1::PostsController < Api::V1::ApplicationController
  def index
    @posts = [{ id: 1, title: 'Test1' }]
  end
end