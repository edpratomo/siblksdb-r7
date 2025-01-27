class RefundsController < ApplicationController
  before_action :set_refund, only: %i[ show edit update destroy ]

  skip_after_action :verify_same_origin_request
  
  # GET /refunds or /refunds.json
  def index
    @filterrific = initialize_filterrific(
      Refund,
      params[:filterrific],
      :select_options => {
        sorted_by: Refund.options_for_sorted_by
      }
    ) or return

    @refunds = Refund.filterrific_find(@filterrific).paginate(page: params[:page], per_page: 10)
  
    respond_to do |format|
      format.html
      format.js { render partial: 'list', locals: { refunds: @refunds } }
    end
  end

  # GET /refunds/1 or /refunds/1.json
  def show
  end

  # GET /refunds/new
  def new
    @refund = Refund.new
  end

  # GET /refunds/1/edit
  def edit
  end

  # POST /refunds or /refunds.json
  def create
    @refund = Refund.new(refund_params)

    respond_to do |format|
      if @refund.save
        format.html { redirect_to @refund, notice: "Refund was successfully created." }
        format.json { render :show, status: :created, location: @refund }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @refund.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /refunds/1 or /refunds/1.json
  def update
    respond_to do |format|
      if @refund.update(refund_params)
        format.html { render partial: 'status', locals: {refund: @refund} }
        #format.html { redirect_to @refund, notice: "Refund was successfully updated." }
        format.json { render :show, status: :ok, location: @refund }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @refund.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /refunds/1 or /refunds/1.json
  def destroy
    @refund.destroy!

    respond_to do |format|
      format.html { redirect_to refunds_path, status: :see_other, notice: "Refund was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_refund
      @refund = Refund.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def refund_params
      params.fetch(:refund, {}).permit(:paid_at)
    end
end
