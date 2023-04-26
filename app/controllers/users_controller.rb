class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
    render json: @users
  end

  def show
    render json: @user
  end

  def create
    @user = User.new(user_params)
    @user.save
    render json: @user, status: :created
  end

  def update
    if params[:name].empty?
      render json: "Can't update without a name!"
    elsif !@user
      render json: "Couldn't find user"
    else
      @user.update(user_params)
      render json: @user
    end
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
    @user = User.find_by(params[:user_name])
  end

  def user_params
    params.permit(:name)
  end
end
