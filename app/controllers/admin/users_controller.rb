class Admin::UsersController < Admin::BaseController
  
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    
    where = ""
    args  = []

    if !params[:email].blank?
      where += "users.email ILIKE ? "
      args  << "%#{params[:email]}%"
    end

    if !params[:first_name].blank?
      where += " AND " if !where.blank?
      where += "users.first_name ILIKE ? "
      args  << "%#{params[:first_name]}%"
    end

    if !params[:last_name].blank?
      where += " AND " if !where.blank?
      where += "users.last_name ILIKE ? "
      args  << "%#{params[:last_name]}%"
    end
    
    @users = User
              .where(where, *args)
              .order(created_at: :desc)
              .page params[:page]
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "user was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: "user was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "user was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

end
