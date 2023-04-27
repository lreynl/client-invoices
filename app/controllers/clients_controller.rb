class ClientsController < ApplicationController
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  @apr = 0.10

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

  def summary
    client = Client.find_by(params[:name])
    today = Date.parse(Time.now.to_date.strftime('%F'))
    
    fees_due = client.invoices.map do |invoice| 
      amount = invoice.invoice_amount_cents
      if invoice.status == 'closed'
        get_interest(amount, apr, (invoice.updated_at - invoice.created_at).to_i)
      elsif invoice.status == 'purchased'
        get_interest(amount, apr, (today - invoice.purchase_date).to_i)
      else
        0
      end
    end.sum

    render json: { current_fees_due: Money.new(fees_due).format }
  end

  private

  def get_interest(p, r, t)
    time = t.to_f / 365.0
    p * Math.exp(r * time) - p
  end

  def set_client
    @client = Client.find_by(params[:client_name])
  end

  def client_params
    params.permit(:name)
  end
end
