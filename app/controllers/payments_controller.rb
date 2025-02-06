class PaymentsController < ApplicationController
  before_action :set_payment, only: %i[ show edit update destroy ]
  before_action :set_invoice, only: %i[ new create ]

  #layout false, only: %i[ new ]

  # GET /payments or /payments.json
  def index
    @payments = Payment.all
  end

  # GET /payments/1 or /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
    @remaining_balance = if @invoice.paid
      0
    else
      @invoice.amount - @invoice.total_paid
    end
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments or /payments.json
  def create
    @payment = @invoice.payments.build(payment_params)

    respond_to do |format|
      if @payment.save
        flash[:notice] = ["Payment was successfully created."]
        if @invoice.refund
          flash[:notice] << "Refund created."
          @refunds_count = Refund.already_paid('0').size
          format.turbo_stream
        else
          format.html { render partial: 'invoices/status', locals: {invoice: @invoice} }
          format.json { render :show, status: :created, location: @payment }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /payments/1 or /payments/1.json
  def update
    respond_to do |format|
      if @payment.update(payment_params)
        format.html { redirect_to @payment, notice: "Payment was successfully updated." }
        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1 or /payments/1.json
  def destroy
    @payment.destroy!

    respond_to do |format|
      format.html { redirect_to payments_path, status: :see_other, notice: "Payment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    def set_invoice
      @invoice = Invoice.find(params[:invoice_id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = 'Invoice not found.'
      redirect_to invoices_path
    end

    # Only allow a list of trusted parameters through.
    def payment_params
      params.fetch(:payment, {}).permit(:amount, :method).tap do |whitelisted|
        # ungroup digits
        whitelisted[:amount] = whitelisted[:amount].tr('.', '').to_i #  gsub(/[^0-9.]/, '').to_f
      end
    end
end
