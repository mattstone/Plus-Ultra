class Dashboard::ProductsController < Dashboard::BaseController
  before_action :set_product, only: %i[ show ]

  # GET /products or /products.json
  def index
    
    # set_start_and_end_date

    # where = ""
    # args  = []
    # 
    # if !params[:name].blank?
    #   where += "products.name ILIKE ? "
    #   args  << "%#{params[:name]}%"
    # end
    # 
    # if !params[:sku].blank?
    #   where += "products.sku ILIKE ? "
    #   args  << "%#{params[:sku]}%"
    # end
    
    # @products = Product
    #           .where(for_sale: true)
    #           .where(where, *args)
    #           .order(created_at: :desc)
    #           .page params[:page]

    # @products = current_user.orders.products
    #              .order(created_at: :desc)
    #              .page params[:page]
    
    @products = if !params[:name].blank?
                  Product 
                   .joins(:orders)
                   .joins("left join transactions on transactions.order_id = orders.id")
                   .where(purchase_type: "purchase")
                   .where({ orders: { user_id: current_user.id }})
                   .where({ transactions: { status: "cleared_funds" }})
                   .order(created_at: :desc)
                   .page params[:page]
                else 
                  Product 
                   .joins(:orders)
                   .joins("left join transactions on transactions.order_id = orders.id")
                   .where(purchase_type: "purchase")
                   .where({ orders: { user_id: current_user.id }})
                   .where({ transactions: { status: "cleared_funds" }})
                   .order(created_at: :desc)
                   .page params[:page]
                end
                  
  end

  # GET /products/1 or /products/1.json
  def show
    @meta_description = @product.meta_description if !@product.meta_description.blank?
    @meta_keywords    = @product.meta_keywords    if !@product.meta_keywords.blank?
  end

  # GET /products/new
  # def new
  #   @product = Product.new
  # end
  # 
  # # GET /products/1/edit
  # def edit
  # end
  # 
  # # POST /products or /products.json
  # def create
  #   @product = Product.new(product_params)
  # 
  #   respond_to do |format|
  #     if @product.save
  #       format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
  #       format.json { render :show, status: :created, location: @product }
  #     else
  #       format.html { render :new, status: :unprocessable_entity }
  #       format.json { render json: @product.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # PATCH/PUT /products/1 or /products/1.json
  # def update
  #   respond_to do |format|
  #     if @product.update(product_params)
  #       format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
  #       format.json { render :show, status: :ok, location: @product }
  #     else
  #       format.html { render :edit, status: :unprocessable_entity }
  #       format.json { render json: @product.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # DELETE /products/1 or /products/1.json
  # def destroy
  #   @product.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
  #     format.json { head :no_content }
  #   end
  # end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.fetch(:product, {})
    end
end
