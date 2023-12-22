require File.join(__dir__, "./ISBaseWatir.rb")

class ISEvents < ISBaseWatir
  
  def initialize 
    super
    
    setup_for_tests
    create_and_confirm_admin_user!
    
    sign_in_admin
    
    test_runner

    tests_complete
    
  end
  
  def setup_for_tests
    super 

    Event.destroy_all
    
  end
  
  def test_runner 
    super
    
    @user = test_user_db
    
    browse_to_events
    
    new_event
    
    edit_event
    
    invitiations
  end
  
  def browse_to_events
    header("Browse to events")
    
    wait_for_text "Signed in successfully"

    click "/admin/users"

    wait_for_text "Manage Users"
    
    click "/admin/users/#{@user.id}/events"

    wait_for_text "Manage User Events"
  end
  
  def new_event 
    header("New event")
    
    click "/admin/users/#{@user.id}/events/new"
    
    wait_for_text "New event"
    sleep 1
    
    event = test_event
    
    # user_id: test_user_db.id,
    # event_type: Event::event_types[:reminder],
    # name: "test event",
    # location: "1 Martin Place, Sydney NSW, Australia",
    # video_url: "",
    # start_datetime: Time.now + 1.month,
    # end_datetime: Time.now + 1.month + 1.hour,
    # invitees: []
    
    set_select('event_event_type', 'meeting')
    
    set_datetime_field("event_start_datetime", event[:start_datetime])
    set_datetime_field("event_end_datetime",   event[:end_datetime])

    set_text_field('event_name',     event[:name])
    set_text_field('event_location', event[:location])
    
    sleep 2 # Wait for map to draw
    
    set_text_field('query', 't')

    sleep 2
    
    click_button "search_results_#{test_user_db.id}"

    click_button "admin_user_event_button"
    
    wait_for_text "Event was successfully created"
  end
  

  def edit_event
    header("Edit event")

    sleep 1
    
    click "/admin/users/#{@user.id}/events/#{test_event_db.id}/edit"
    
    wait_for_text "Editing event"
    
    set_text_field('event_name', changed)

    click_button "admin_user_event_button"
    
    wait_for_text "Event was successfully updated"
    wait_for_text changed
  end
  
  def invitiations
    header("Invitiations")
    
    event = test_event_db
    first = event.invitees.first 
    
    case first.class.to_s.downcase == "hash"
    when true  then good("first invite is a hash")
    when false then good("first invite is not a hash")
    end

    case first["email"] == @user.email
    when true  then good("email is good")
    when false then good("email is not good: #{first["email"]}")
    end

    case !first["uuid"].blank?
    when true  then good("uuid is good")
    when false then good("uuid is not good: #{first["uuid"]}")
    end

    # Build accept and decline urls
    routes      = Rails.application.routes.url_helpers
    accept_url  = routes.accept_invitation_url(event_id:  event.id, uuid: first["uuid"])
    decline_url = routes.decline_invitation_url(event_id: event.id, uuid: first["uuid"])
    
    case !accept_url.blank?
    when true  then good("accept_url is good")
    when false then good("accept_url is not good: #{accept_url}")
    end

    case !decline_url.blank?
    when true  then good("decline_url is good")
    when false then good("decline_url is not good: #{decline_url}")
    end
    
    # accept invitation 
    goto accept_url
    
    wait_for_text "accepted"
    
    event.reload
    
    first = event.invitees.first 

    case first["accepted"] == true
    when true  then good("accepted is good")
    when false then good("accepted is not good: #{first.inspect}")
    end

    case !first["date_accepted"].nil?
    when true  then good("date_accepted is good")
    when false then good("date_accepted is not good: #{first.inspect}")
    end
    
    # decline invitation

    goto decline_url

    event.reload
    
    first = event.invitees.first 

    case first["accepted"] == false
    when true  then good("accepted is false")
    when false then good("accepted is not false: #{first.inspect}")
    end

    case first["date_accepted"].nil?
    when true  then good("date_accepted is nil")
    when false then good("date_accepted is not nil: #{first.inspect}")
    end
    
  end
  
end


ISEvents.new