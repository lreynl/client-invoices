class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all
    render json: @posts
  end

  def show
    render json: @post
  end

  def create
    @post = Post.new(post_params)
    @post.status = 'draft'
    @post.uuid = SecureRandom.uuid
    if @post.save
      render json: { created: @post.uuid }, status: :created
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  #need to retain current values if omitted
  def update
    if params[:body].empty?
      render json: "Can't update without a body!"
    elsif !@post
      render json: "Couldn't find post"
    else
      @post.update(post_params)
      render json: @post
    end
  end

  def destroy
    if !@post
      render json: "Couldn't find post"
    else
      @uuid = @post.uuid
      if @post.destroy
        render json: "Deleted post #{@uuid}"
      else
        render json: "Couldn't delete post #{@uuid}"
      end
    end
  end

  private
  def set_post
    @post = Post.find_by(params[:uuid])
  end

  def post_params
    params.permit(:body, :status, :file)
  end
end
