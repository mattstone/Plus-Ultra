class EventsController < ApplicationController
  before_action :set_event, only: %i[ accept_invitation decline_invitation ]

  def accept_invitation
    @event.accept_invitation!(params[:uuid]) if @event and params[:uuid]
  end 

  def decline_invitation 
    @event.decline_invitation!(params[:uuid]) if @event and params[:uuid]
  end
  
  private 
  
  def set_event 
    @event = Event.find(params[:event_id])
  end

end
