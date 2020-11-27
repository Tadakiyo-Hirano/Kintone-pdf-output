require 'test_helper'

class KintoneAppsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get kintone_apps_show_url
    assert_response :success
  end

  test "should get edit" do
    get kintone_apps_edit_url
    assert_response :success
  end

end
