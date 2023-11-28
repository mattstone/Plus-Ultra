class Admin::BulkEmailsController < Admin::BaseController
  before_action :set_bulk_email, only: %i[ show edit update destroy send_bulk_email ]

  # GET /bulk_emails or /bulk_emails.json
  def index
    where = ""
    args  = []
    
    # if !params[:name].blank?
    #   where += "campaigns.name ILIKE ? "
    #   args  << "%#{params[:name]}%"
    # end
    # 
    # if !params[:tag].blank?
    #   where += "campaigns.tag ILIKE ? "
    #   args  << "%#{params[:tag]}%"
    # end
    
    
    @bulk_emails = BulkEmail
                    .where(where, *args)
                    .order(created_at: :desc)
                    .page params[:page]
    
  end

  # GET /bulk_emails/1 or /bulk_emails/1.json
  def show
  end

  # GET /bulk_emails/new
  def new
    @bulk_email = BulkEmail.new
  end

  # GET /bulk_emails/1/edit
  def edit
  end

  # POST /bulk_emails or /bulk_emails.json
  def create
    @bulk_email = BulkEmail.new(bulk_email_params)

    respond_to do |format|
      if @bulk_email.save
        format.html { redirect_to admin_bulk_emails_path, notice: "Bulk email was successfully created." }
        format.json { render :show, status: :created, location: @bulk_email }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @bulk_email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bulk_emails/1 or /bulk_emails/1.json
  def update
    respond_to do |format|
      if @bulk_email.update(bulk_email_params)
        format.html { redirect_to admin_bulk_emails_path, notice: "Bulk email was successfully updated." }
        format.json { render :show, status: :ok, location: @bulk_email }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @bulk_email.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bulk_emails/1 or /bulk_emails/1.json
  def destroy
    @bulk_email.destroy

    respond_to do |format|
      format.html { redirect_to admin_bulk_emails_path, notice: "Bulk email was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  def send_bulk_email 
    
    @bulk_email.send!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bulk_email
      @bulk_email = BulkEmail.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bulk_email_params
      params.fetch(:bulk_email, {}).permit(
        :mailing_list_id,
        :communication_id
      )
    end
    
end
