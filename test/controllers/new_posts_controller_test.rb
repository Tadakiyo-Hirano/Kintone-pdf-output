require 'test_helper'

class NewPostsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get new_posts_show_url
    assert_response :success
  end

end
