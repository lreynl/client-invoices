class UsersController < ApplicationController
  def index
    @user = User.all
    render json: @user
  end

  def show
  end

  def create
    @user = User.new(user_params)
    @user.save
    render json: @user, status: :created
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.permit(:name)
  end
end
