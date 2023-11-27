class Admin::MailingListsController < Admin::BaseController
  before_action :set_mailing_list, only: %i[ show edit update destroy subscribers_count ]

  # GET /mailing_lists or /mailing_lists.json
  def index
    
    where = ""
    args  = []

    if !params[:name].blank?
      where += "mailing_lists.name ILIKE ? "
      args  << "%#{params[:name]}%"
    end

    @mailing_lists = MailingList
                      .where(where, *args)
                      .order(created_at: :desc)
                      .page params[:page]
  end

  # GET /mailing_lists/1 or /mailing_lists/1.json
  def show
  end

  # GET /mailing_lists/new
  def new
    @mailing_list = MailingList.new
  end

  # GET /mailing_lists/1/edit
  def edit
  end

  # POST /mailing_lists or /mailing_lists.json
  def create
    @mailing_list = MailingList.new(mailing_list_params)

    respond_to do |format|
      if @mailing_list.save
        format.html { redirect_to admin_mailing_lists_url, notice: "Mailing list was successfully created." }
        format.json { render :show, status: :created, location: @mailing_list }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @mailing_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mailing_lists/1 or /mailing_lists/1.json
  def update
    respond_to do |format|
      if @mailing_list.update(mailing_list_params)
        format.html { redirect_to admin_mailing_lists_url, notice: "Mailing list was successfully updated." }
        format.json { render :show, status: :ok, location: @mailing_list }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @mailing_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mailing_lists/1 or /mailing_lists/1.json
  def destroy
    @mailing_list.destroy

    respond_to do |format|
      format.html { redirect_to admin_mailing_lists_url, notice: "Mailing list was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def subscribers_count

    respond_to do |format|
     format.json { render json: { subscribers: @mailing_list.subscribers.count} }
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mailing_list
      @mailing_list = MailingList.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def mailing_list_params
      params.require(:mailing_list).permit(
        :name
      )      
    end
end
