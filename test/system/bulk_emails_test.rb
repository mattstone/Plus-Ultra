require "application_system_test_case"

class BulkEmailsTest < ApplicationSystemTestCase
  setup do
    @bulk_email = bulk_emails(:one)
  end

  test "visiting the index" do
    visit bulk_emails_url
    assert_selector "h1", text: "Bulk emails"
  end

  test "should create bulk email" do
    visit bulk_emails_url
    click_on "New bulk email"

    click_on "Create Bulk email"

    assert_text "Bulk email was successfully created"
    click_on "Back"
  end

  test "should update Bulk email" do
    visit bulk_email_url(@bulk_email)
    click_on "Edit this bulk email", match: :first

    click_on "Update Bulk email"

    assert_text "Bulk email was successfully updated"
    click_on "Back"
  end

  test "should destroy Bulk email" do
    visit bulk_email_url(@bulk_email)
    click_on "Destroy this bulk email", match: :first

    assert_text "Bulk email was successfully destroyed"
  end
end
