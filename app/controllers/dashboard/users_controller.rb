class Dashboard::UsersController < Dashboard::BaseController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /Users or /Users.json
  # def index
  #   @users = User.all
  # end

  # GET /Users/1 or /Users/1.json
  def show
    
    redirect_to dashboard_dashboard_path if current_user.id != @user.id
  end

  # GET /Users/new
  # def new
  #   @user = User.new
  # end
  # 
  # # GET /Users/1/edit
  # def edit
  # end
  # 
  # # POST /Users or /Users.json
  # def create
  #   @user = User.new(User_params)
  # 
  #   respond_to do |format|
  #     if @user.save
  #       format.html { redirect_to User_url(@user), notice: "User was successfully created." }
  #       format.json { render :show, status: :created, location: @user }
  #     else
  #       format.html { render :new, status: :unprocessable_entity }
  #       format.json { render json: @user.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # PATCH/PUT /Users/1 or /Users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        #format.html { redirect_to dashboard_user_url(@user), notice: "Successfully updated." }
        #format.json { render :show, status: :ok, location: @user }
        @success = "Successfully updated"
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  # 
  # # DELETE /Users/1 or /Users/1.json
  # def destroy
  #   @user.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to Users_url, notice: "User was successfully destroyed." }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # See application_controller for user_params
    # Only allow a list of trusted parameters through.
    # def User_params
    #   params.fetch(:User, {})
    # end
end
