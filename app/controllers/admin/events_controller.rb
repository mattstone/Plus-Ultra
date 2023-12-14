class Admin::EventsController < Admin::BaseController
  before_action :set_user
  before_action :set_event, only: %i[ show edit update destroy ]

  # GET /events or /events.json
  def index
    where = ""
    args  = []
    
    @events = Event
                .where(where, *args)
                .order(created_at: :desc)
                .page params[:page]
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = @user.events.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = @user.events.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to admin_user_events_url(current_user), notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to admin_user_events_url(current_user), notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy!

    respond_to do |format|
      format.html { redirect_to admin_user_events_url(current_user), notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end
  
  #
  # Invitee
  #
  
  def search_for_invitee
    @invitees = params[:invitees]
    @results  = User 
                 .where('email ILIKE ?', "%#{params[:query]}%")
                 .limit(10)
    
    respond_to do |format|
      # format.json { render json: @results }
      format.turbo_stream
    end
  end 
  
  def add_invitee
    @invitees  = params[:invitees]
    
    if !@invitees.include?(params[:email])
      @invitees += ", " if !@invitees.blank?
      @invitees += params[:email]
    end
  end
  
  def remove_invitee
    @invitees = params[:invitees].split(", ")
    @invitees.delete_at(params[:element].to_i)
    @invitees = @invitees.join(", ")
    
    Rails.logger.info @invitees.inspect.to_s.red
  end

  private
    # Use callbacks to share common setup or constraints between actions.

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.fetch(:event, {}).permit(
        :event_type,
        :start_datetime,
        :end_datetime,
        :name,
        :location,
        :invitees
      )
      
    end
end
