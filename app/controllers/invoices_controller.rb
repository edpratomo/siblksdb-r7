class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[ show edit update destroy ]
  before_action :set_payment, only: %i[ index ]

  skip_after_action :verify_same_origin_request
  
  # GET /invoices or /invoices.json
  def index
    @filterrific = initialize_filterrific(
      Invoice,
      params[:filterrific],
      :select_options => {
        sorted_by: Invoice.options_for_sorted_by,
        already_paid: Invoice.options_for_already_paid
      }
    ) or return

    @invoices = Invoice.filterrific_find(@filterrific).paginate(page: params[:page], per_page: 10)

    respond_to do |format|
      format.html
      format.js { render partial: 'list', locals: { invoices: @invoices } }
    end
  end

  # GET /invoices/1 or /invoices/1.json
  def show
    if params[:inline]
      render partial: 'status', locals: {invoice: @invoice}
    elsif params[:modal]
      render partial: 'show_modal', locals: {invoice: @invoice}
    else
      respond_to do |format|
        format.html
        format.json { render :show, status: :ok, location: @invoice }
      end
    end
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
  end

  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices or /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to invoice_url(@invoice), notice: "Invoice was successfully created." }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1 or /invoices/1.json
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to invoice_url(@invoice), notice: "Invoice was successfully updated." }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1 or /invoices/1.json
  def destroy
    @invoice.destroy

    respond_to do |format|
      format.html { redirect_to invoices_url, notice: "Invoice was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    def set_payment
      @payment = Payment.new
    end

    # Only allow a list of trusted parameters through.
    def invoice_params
      params.fetch(:invoice, {})
    end
end
