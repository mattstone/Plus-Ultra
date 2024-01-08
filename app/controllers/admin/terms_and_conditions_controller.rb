class Admin::TermsAndConditionsController < Admin::BaseController
  before_action :set_terms_and_condition, only: %i[ show edit update destroy cancel ]

  # GET /TermsAndConditions or /TermsAndConditions.json
  def index
    @terms_and_conditions = TermsAndCondition
                      .order(created_at: :desc)
                      .page params[:page]
end

  # GET /TermsAndConditions/1 or /TermsAndConditions/1.json
  def show
  end

  # GET /TermsAndConditions/new
  def new
    @terms_and_condition = TermsAndCondition.where(status: "published").order(updated_at: :desc).first
    @terms_and_condition = TermsAndCondition.new if @terms_and_condition.nil?
  end

  # GET /TermsAndConditions/1/edit
  def edit
  end

  # POST /TermsAndConditions or /TermsAndConditions.json
  def create
    @terms_and_condition = TermsAndCondition.new(terms_and_condition_params)

    respond_to do |format|
      if @terms_and_condition.save
        format.html { redirect_to admin_terms_and_conditions_url(@terms_and_condition), notice: "Terms and Condition was successfully created." }
        format.json { render :show, status: :created, location: @terms_and_condition }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @terms_and_condition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /TermsAndConditions/1 or /TermsAndConditions/1.json
  def update
    respond_to do |format|
      if @terms_and_condition.update(terms_and_condition_params)
        format.html { redirect_to admin_terms_and_conditions_url(@terms_and_condition), notice: "Terms and Condition was successfully updated." }
        format.json { render :show, status: :ok, location: @terms_and_condition }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @terms_and_condition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /TermsAndConditions/1 or /TermsAndConditions/1.json
  # def destroy
  #   @terms_and_condition.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to admin_terms_and_conditions_url, notice: "Terms and Condition was successfully destroyed." }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_terms_and_condition
      @terms_and_condition = TermsAndCondition.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def terms_and_condition_params
      params.fetch(:terms_and_condition, {}).permit(
        :content,
        :status
      )
    end

end
