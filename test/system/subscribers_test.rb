require "application_system_test_case"

class SubscribersTest < ApplicationSystemTestCase
  setup do
    @subscriber = subscribers(:one)
  end

  test "visiting the index" do
    visit subscribers_url
    assert_selector "h1", text: "Subscribers"
  end

  test "should create subscriber" do
    visit subscribers_url
    click_on "New subscriber"

    click_on "Create Subscriber"

    assert_text "Subscriber was successfully created"
    click_on "Back"
  end

  test "should update Subscriber" do
    visit subscriber_url(@subscriber)
    click_on "Edit this subscriber", match: :first

    click_on "Update Subscriber"

    assert_text "Subscriber was successfully updated"
    click_on "Back"
  end

  test "should destroy Subscriber" do
    visit subscriber_url(@subscriber)
    click_on "Destroy this subscriber", match: :first

    assert_text "Subscriber was successfully destroyed"
  end
end
