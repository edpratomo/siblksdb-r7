class AdmissionsController < ApplicationController
  before_action :set_admission, only: %i[ show edit update destroy ]
  before_action :set_courses_options, only: %i[ new edit create update ]

  #protect_from_forgery except: :index
  skip_after_action :verify_same_origin_request

  # GET /admissions or /admissions.json
  def index
    @filterrific = initialize_filterrific(
      Admission,
      params[:filterrific],
      select_options: {
        sorted_by: Admission.options_for_sorted_by,
      },
    ) or return

    ff_result = Admission.filterrific_find(@filterrific)
    Rails.logger.debug("ff_result: #{ff_result.inspect}")
    @admissions = ff_result.paginate(page: params[:page])
    #@admissions = @filterrific.find.page(params[:page]).e

    respond_to do |format|
      format.html
      format.js { render partial: 'list', locals: { admissions: @admissions } }
    end
  end

  def suggestions
    @admissions = Admission.fuzzy_search(name: params[:q])
    render :layout => 'plain'
  end

  # GET /admissions/1 or /admissions/1.json
  def show
  end

  # GET /admissions/new
  def new
    @admission = Admission.new
  end

  # GET /admissions/1/edit
  def edit
  end

  # POST /admissions or /admissions.json
  def create
    @admission = Admission.new(admission_params)

    respond_to do |format|
      if @admission.save
        format.html { redirect_to admissions_path, notice: "Admission was successfully created." }
        format.json { render :show, status: :created, location: @admission }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @admission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admissions/1 or /admissions/1.json
  def update
    respond_to do |format|
      if @admission.update(admission_params)
        format.html { redirect_to admission_url(@admission), notice: "Admission was successfully updated." }
        format.json { render :show, status: :ok, location: @admission }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admissions/1 or /admissions/1.json
  def destroy
    @admission.destroy

    respond_to do |format|
      format.html { redirect_to admissions_url, notice: "Admission was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admission
      @admission = Admission.find(params[:id])
    end

    def set_courses_options
      @courses_options = Course.options_for_checkbox
    end

    # Only allow a list of trusted parameters through.
    def admission_params
      params.fetch(:admission, {}).permit(:name, :sex, :birthdate, :birthplace, :course_ids => [])
    end
end
