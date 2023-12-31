class Dashboard::SubscriptionsController < Dashboard::BaseController
  before_action :set_subscription, only: %i[ show cancel ]

  # GET /subscriptions or /subscriptions.json
  def index
    @subscriptions = current_user.subscriptions
                      .order(created_at: :desc)
                      .page params[:page]

  end

  # GET /subscriptions/1 or /subscriptions/1.json
  def show
    redirect_to dashboard_dashboard_path if current_user.id != @subscription.user_id
  end

  # GET /subscriptions/new
  # def new
  #   @subscription = Subscription.new
  # end
  # 
  # # GET /subscriptions/1/edit
  # def edit
  # end
  # 
  # # POST /subscriptions or /subscriptions.json
  # def create
  #   @subscription = Subscription.new(subscription_params)
  # 
  #   respond_to do |format|
  #     if @subscription.save
  #       format.html { redirect_to subscription_url(@subscription), notice: "Subscription was successfully created." }
  #       format.json { render :show, status: :created, location: @subscription }
  #     else
  #       format.html { render :new, status: :unprocessable_entity }
  #       format.json { render json: @subscription.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # PATCH/PUT /subscriptions/1 or /subscriptions/1.json
  # def update
  #   respond_to do |format|
  #     if @subscription.update(subscription_params)
  #       format.html { redirect_to subscription_url(@subscription), notice: "Subscription was successfully updated." }
  #       format.json { render :show, status: :ok, location: @subscription }
  #     else
  #       format.html { render :edit, status: :unprocessable_entity }
  #       format.json { render json: @subscription.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # DELETE /subscriptions/1 or /subscriptions/1.json
  # def destroy
  #   @subscription.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to subscriptions_url, notice: "Subscription was successfully destroyed." }
  #     format.json { head :no_content }
  #   end
  # end
  
  def cancel 
    cancel_subscription if current_user.id == @subscription.user_id 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subscription
      @subscription = Subscription.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    # def subscription_params
    #   params.fetch(:subscription, {})
    # end
end
