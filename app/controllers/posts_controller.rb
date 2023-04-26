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
    @user = User.find_by(params[:name])
    @post = @user.posts.new(post_params)
    # @post.status = 'draft'
    # puts @post.status
    # @post.save
    # puts @post[:errors]
    # @post = Post.new(post_params)
    @post.uuid = SecureRandom.uuid
    @post.file_url = @post.file.blob.service_url
    if @post.save
      render json: { created: @post }, status: :created
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  #need to retain current values if omitted
  #should put this validation in the model
  def update
    puts post_params
    puts @post[:errors]
    if params[:body] && params[:body].empty?
      render json: "Can't update without a body!"
    elsif !@post
      render json: "Couldn't find post"
    else
      if @post.update(post_params)
        render json: @post
      else
        render json: @post.errors, status: :unprocessable_entity
      end
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
        render json: "Couldn't delete post #{@uuid}", status: :unprocessable_entity
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
