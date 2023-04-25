class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

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

  def destroy
    if !@user
      render json: "Couldn't find user"
    else
      @name = @user.name
      if @user.destroy
        render json: "Deleted user #{@name}"
      else
        render json: "Couldn't delete user #{@name}"
      end
    end
  end

  private
  def set_user
    @user = User.find_by(name: params[:id])
  end

  def user_params
    params.permit(:name)
  end
end
