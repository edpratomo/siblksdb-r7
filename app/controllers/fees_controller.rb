class FeesController < ApplicationController
  before_action :set_fee, only: %i[ show edit update destroy ]

  # GET /fees or /fees.json
  def index
    @fee = params[:type].constantize.new
    @fee.type = params[:type]
    @courses_options = Course.options_for_select
    @programs_options = Program.options_for_select
    
    Rails.logger.debug("controller: #{controller_name}")
    Rails.logger.debug("request_path: #{request.path}")
    @fees = Fee.where(:type => params[:type])
  end

  # GET /fees/1 or /fees/1.json
  def show
  end

  # GET /fees/new
  def new
    # @fee = Fee.new
    @fee = params[:type].constantize.new
    @fee.type = params[:type]
  end

  # GET /fees/1/edit
  def edit
  end

  # POST /fees or /fees.json
  def create
    @fee = Fee.new(fee_params)
    @fee.amount = @fee.amount.to_i

    respond_to do |format|
      if @fee.save
        format.html { redirect_to request.path, notice: "Fee was successfully created." }
        format.json { render :show, status: :created, location: @fee }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @fee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fees/1 or /fees/1.json
  def update
    respond_to do |format|
      if @fee.update(fee_params)
        format.html { redirect_to @fee, notice: "Fee was successfully updated." }
        format.json { render :show, status: :ok, location: @fee }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @fee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fees/1 or /fees/1.json
  def destroy
    @fee.destroy!

    respond_to do |format|
      format.html { redirect_to fees_path, status: :see_other, notice: "Fee was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fee
      @fee = Fee.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def fee_params
      #params.fetch(:fee, {})
      Rails.logger.debug("params type: #{params[:type]}")
      permit_map = {
        "CourseFee" => [:course_id, :amount, :active_since, :type],
        "BookUniformFee" => [:program_id, :amount, :active_since, :type],
        "AdmissionFee" => [:amount, :active_since, :type]
      }
      %w[RegCourseFee IntCourseFee ExtCourseFee].each do |course_fee|
        permit_map[course_fee] = permit_map["CourseFee"]
      end
      allowed_params = permit_map[params[:type]]
      Rails.logger.debug("permit_map: #{permit_map}")
      Rails.logger.debug("allowed_params: #{allowed_params}")
      if allowed_params
        params.require(params[:type].underscore.to_sym).permit(*allowed_params)
      end
    end
end
