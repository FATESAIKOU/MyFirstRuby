class PostsController < ApplicationController
  def index
    return_str = "Hello, World!"
    a = 1 + 1
    b = 2 + 1
    render json: { message: return_str }
  end
end
