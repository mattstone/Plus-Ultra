class Admin::CampaignsController < Admin::BaseController
  before_action :set_channel
  before_action :set_campaign, only: %i[ show edit update destroy ]

  # GET /Campaigns or /Campaigns.json
  def index
    where = ""
    args  = []
    

    if !params[:name].blank?
      where += "campaigns.name ILIKE ? "
      args  << "%#{params[:name]}%"
    end
    
    if !params[:tag].blank?
      where += "campaigns.tag ILIKE ? "
      args  << "%#{params[:tag]}%"
    end
    
    
    @campaigns = @channel.campaigns
                  .where(where, *args)
                  .order(name: :asc)
                  .page params[:page]
  end

  # GET /Campaigns/1 or /Campaigns/1.json
  def show
  end

  # GET /Campaigns/new
  def new
    @campaign = @channel.campaigns.new
  end

  # GET /Campaigns/1/edit
  def edit
  end

  # POST /Campaigns or /Campaigns.json
  def create
    @campaign = @channel.campaigns.new(campaign_params)

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to admin_channel_campaigns_url(@channel), notice: "Campaign was successfully created." }
        format.json { render :show, status: :created, location: @campaign }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /Campaigns/1 or /Campaigns/1.json
  def update
    respond_to do |format|
      if @campaign.update(campaign_params)
        format.html { redirect_to admin_channel_campaigns_url(@channel), notice: "Campaign was successfully updated." }
        format.json { render :show, status: :ok, location: @campaign }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /Campaigns/1 or /Campaigns/1.json
  def destroy
    @campaign.destroy

    respond_to do |format|
      format.html { redirect_to admin_channel_campaigns_url(@channel), notice: "Campaign was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_channel
      @channel = Channel.find(params[:channel_id])
    end

    def set_campaign
      @campaign = Campaign.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def campaign_params
      params.fetch(:campaign, {}).permit(
        :name,
        :tag,
        :redirect_url
      )      
    end
end
