class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    
    where = ""
    args  = []

    if !params[:name].blank?
      where += "products.name ILIKE ? "
      args  << "%#{params[:name]}%"
    end

    if !params[:sku].blank?
      where += "products.sku ILIKE ? "
      args  << "%#{params[:sku]}%"
    end
    
    @products = Product
              .where(where, *args)
              .order(created_at: :desc)
              .page params[:page]
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to admin_products_url, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to admin_products_url, notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to admin_products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.fetch(:product, {}).permit(
        :name,
        :sku,
        :price_in_cents,
        :purchase_type,
        :billing_type,
        :teaser,
        :description,
        :main_image,
        :stripe_product_api_id, 
        :for_sale,
        :meta_description,
        :meta_keywords        
      )
    end
    
end
