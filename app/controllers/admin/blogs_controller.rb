class Admin::BlogsController < Admin::BaseController
  before_action :set_blog, only: %i[ show edit update destroy ]

  # GET /blogs or /blogs.json
  def index
    
    where = ""
    args  = []

    if !params[:title].blank?
      where += "blogs.title ILIKE ? "
      args  << "%#{params[:title]}%"
    end    
    
    @blogs = Blog.all
              .where(where, *args)
              .order(created_at: :desc)
              .page params[:page]
  end

  # GET /blogs/1 or /blogs/1.json
  def show
  end

  # GET /blogs/new
  def new
    @blog = Blog.new
  end
  
  # GET /blogs/1/edit
  def edit
  end
  
  # POST /blogs or /blogs.json
  def create
    @blog = Blog.new(blog_params)
  
    respond_to do |format|
      if @blog.save
        format.html { redirect_to admin_blogs_url, notice: "Blog was successfully created." }
        format.json { render :show, status: :created, location: @blog }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /blogs/1 or /blogs/1.json
  def update
    respond_to do |format|
      if @blog.update(blog_params)
        format.html { redirect_to admin_blogs_url, notice: "Blog was successfully updated." }
        format.json { render :show, status: :ok, location: @blog }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /blogs/1 or /blogs/1.json
  def destroy
    @blog.destroy
  
    respond_to do |format|
      format.html { redirect_to admin_blogs_url, notice: "Blog was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_blog
      @blog = Blog.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def blog_params
      params.fetch(:blog, {}).permit(
        :user_id,
        :status,
        :title,
        :teaser,
        :hero_image,
        :content,
        :datetime_to_publish
      )
    end
    

end
