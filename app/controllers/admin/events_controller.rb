class Admin::EventsController < Admin::BaseController
  before_action :set_user
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :set_invitees, only: %i[ search_for_invitee add_invitee remove_invitee ]

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
    
    x = event_params 
    
    Rails.logger.info "create: 1".red
    Rails.logger.info x[:invitees].inspect
    Rails.logger.info x[:invitees].class
    
    
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
    Rails.logger.info params[:invitees]
    
    Rails.logger.info URI.decode_www_form_component(params[:invitees]).green 
    
    @results  = User 
                 .where('email ILIKE ?', "%#{params[:query]}%")
                 .limit(10)
    
    respond_to do |format|
      # format.json { render json: @results }
      format.turbo_stream
    end
  end 
  
  def add_invitee    
    email_exists = false 
    @invitees.each { |i| email_exists = true if i["email"].to_s.downcase == params[:email].to_s.downcase }
    @invitees << Event::invitee(params[:email].to_s.downcase) if !email_exists
  end
  
  def remove_invitee
    # @invitees = params[:invitees].split(", ")
    # @invitees.delete_at(params[:element].to_i)
    # @invitees = @invitees.join(", ")
    
    Rails.logger.info @invitees.inspect
    
    new_invitees = []
    @invitees.each { |i| new_invitees << i if i["email"].downcase != params[:email].downcase }
    @invitees = new_invitees
    
    # @invitees = @invitees.inject([]) { |array, i| array << i if i["email"].downcase != params[:email].downcase}
    
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
    
    def set_invitees
      @invitees = JSON.parse URI.decode_www_form_component(params[:invitees])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      temp = params.fetch(:event, {}).permit(
        :event_type,
        :start_datetime,
        :end_datetime,
        :name,
        :location,
        :invitees
      )
      
      temp[:invitees] = JSON::parse(temp[:invitees])
      temp
    end
end
