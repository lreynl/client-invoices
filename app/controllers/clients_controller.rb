class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]

  def index
    @clients = Client.all
    if @clients.empty?
      render status: :no_content
    else
      render json: @clients
    end
  end

  def show
    render json: @client
  end

  def create
    @client = Client.new(client_params)
    @client.save
    render json: @client, status: :created
  end

  def update
    if params[:name].empty?
      render json: "Can't update without a name!"
    elsif !@client
      render json: "Couldn't find client"
    else
      @client.update(client_params)
      render json: @client
    end
  end

  def destroy
    if !@client
      render json: "Couldn't find client"
    else
      @name = @client.name
      if @client.destroy
        render json: "Deleted client #{@name}"
      else
        render json: "Couldn't delete client #{@name}"
      end
    end
  end

  private

  def set_client
    @client = Client.find_by(params[:client_name])
  end

  def client_params
    params.permit(:name)
  end
end
