class PostsController < ApplicationController
  def index
    render json: { message: "Welcome to TodoApp!" }
  end
end
