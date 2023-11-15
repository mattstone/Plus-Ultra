class Dashboard::OrdersController < Dashboard::BaseController
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  def index
    
    set_start_and_end_date
    
      @orders = if !params[:order_id].blank?
                   Order
                     .where(user_id: current_user.id)
                     .where(id: params[:order_id].to_s.gsub(/(?<=\d),\d+|\D/, ''))
                     .where(created_at: @start_date..@end_date)
                     .order(created_at: :desc)
                     .page params[:page]
                else 
                   Order
                     .where(user_id: current_user.id)
                     .where(created_at: @start_date..@end_date)
                     .order(created_at: :desc)
                     .page params[:page]
                end

  end

  # GET /orders/1 or /orders/1.json
  def show
    redirect_to dashboard_dashboard_path if @order.user_id != current_user.id
  end

  # # GET /orders/new
  # def new
  #   @order = Order.new
  # end
  # 
  # # GET /orders/1/edit
  # def edit
  # end

  # POST /orders or /orders.json
  # def create
  #   @order = Order.new(order_params)
  # 
  #   respond_to do |format|
  #     if @order.save
  #       format.html { redirect_to order_url(@order), notice: "Order was successfully created." }
  #       format.json { render :show, status: :created, location: @order }
  #     else
  #       format.html { render :new, status: :unprocessable_entity }
  #       format.json { render json: @order.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /orders/1 or /orders/1.json
  # def update
  #   respond_to do |format|
  #     if @order.update(order_params)
  #       format.html { redirect_to order_url(@order), notice: "Order was successfully updated." }
  #       format.json { render :show, status: :ok, location: @order }
  #     else
  #       format.html { render :edit, status: :unprocessable_entity }
  #       format.json { render json: @order.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /orders/1 or /orders/1.json
  # def destroy
  #   @order.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.fetch(:order, {})
    end
end
