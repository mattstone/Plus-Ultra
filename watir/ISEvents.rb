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
    
    click_button "admin_user_event_button"
    
      
    sleep 880
  end
  
end


ISEvents.new