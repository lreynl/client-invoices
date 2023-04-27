class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]

  def index
    @invoices = Invoice.all
    if @invoices.empty?
      render status: :no_content
    else
      render json: @invoices
    end
  end

  def show
    render json: @invoice
  end

  def create
    @client = Client.find_by(params[:name])
    @invoice = @client.invoices.new(invoice_params)
    @invoice.invoice_number = SecureRandom.uuid
    @invoice.invoice_amount_cents = params[:invoice_amount].to_f * 100
    @invoice.file_url = @invoice.file.blob.service_url
    if @invoice.save
      render json: { created: @invoice }, status: :created
    else
      render json: { errors: @invoice.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if !@invoice
      render json: "Couldn't find invoice"
    else
      if @invoice.update(invoice_params)
        render json: @invoice
      else
        render json: @invoice.errors, status: :unprocessable_entity
      end
    end
  end

  def destroy
    if !@invoice
      render json: "Couldn't find invoice"
    else
      @invoice_number = @invoice.invoice_number
      if @invoice.destroy
        render json: "Deleted invoice #{@invoice_number}"
      else
        render json: "Couldn't delete invoice #{@invoice_number}", status: :unprocessable_entity
      end
    end
  end

  private

  def set_invoice
    @invoice = Invoice.find_by(params[:invoice_number])
  end

  def invoice_params
    params.permit(:body, :status, :file, :invoice_amount)
  end
end
