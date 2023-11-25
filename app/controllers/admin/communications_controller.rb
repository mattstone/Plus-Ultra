class Admin::CommunicationsController < Admin::BaseController
  before_action :set_communication, only: %i[ show edit update destroy, test ]

  # GET /Communications or /Communications.json
  def index
    where = ""
    args  = []
    

    if !params[:name].blank?
      where += "communications.name ILIKE ? "
      args  << "%#{params[:name]}%"
    end
    
    if !params[:tag].blank?
      where += "communications.tag ILIKE ? "
      args  << "%#{params[:tag]}%"
    end
    
    
    @communications = Communication
                  .where(where, *args)
                  .order(name: :asc)
                  .page params[:page]
  end

  # GET /Communications/1 or /Communications/1.json
  def show
  end

  # GET /Communications/new
  def new
    @communication = Communication.new
  end

  # GET /Communications/1/edit
  def edit
  end

  # POST /Communications or /Communications.json
  def create
    @communication = Communication.new(communication_params)

    respond_to do |format|
      if @communication.save
        format.html { redirect_to admin_communications_url, notice: "Communication was successfully created." }
        format.json { render :show, status: :created, location: @communication }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @communication.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /Communications/1 or /Communications/1.json
  def update
    respond_to do |format|
      if @communication.update(communication_params)
        format.html { redirect_to admin_communications_url, notice: "Communication was successfully updated." }
        format.json { render :show, status: :ok, location: @communication }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @communication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /Communications/1 or /Communications/1.json
  def destroy
    @communication.destroy

    respond_to do |format|
      format.html { redirect_to admin_communications_url, notice: "Communication was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def test 
    UserMailer.communication({ user: current_user, communication: @communication, test: true}).deliver_now!
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_communication
      @communication = Communication.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def communication_params
      params.fetch(:communication, {}).permit(
        :campaign_id,
        :communication_type,
        :lifecycle,
        :name,
        :subject,
        :preview,
        :content
      )      
    end

end
