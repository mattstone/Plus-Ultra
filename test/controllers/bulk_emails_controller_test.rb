require "test_helper"

class BulkEmailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bulk_email = bulk_emails(:one)
  end

  test "should get index" do
    get bulk_emails_url
    assert_response :success
  end

  test "should get new" do
    get new_bulk_email_url
    assert_response :success
  end

  test "should create bulk_email" do
    assert_difference("BulkEmail.count") do
      post bulk_emails_url, params: { bulk_email: {  } }
    end

    assert_redirected_to bulk_email_url(BulkEmail.last)
  end

  test "should show bulk_email" do
    get bulk_email_url(@bulk_email)
    assert_response :success
  end

  test "should get edit" do
    get edit_bulk_email_url(@bulk_email)
    assert_response :success
  end

  test "should update bulk_email" do
    patch bulk_email_url(@bulk_email), params: { bulk_email: {  } }
    assert_redirected_to bulk_email_url(@bulk_email)
  end

  test "should destroy bulk_email" do
    assert_difference("BulkEmail.count", -1) do
      delete bulk_email_url(@bulk_email)
    end

    assert_redirected_to bulk_emails_url
  end
end
