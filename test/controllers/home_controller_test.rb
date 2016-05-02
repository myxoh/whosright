require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get stories" do
    get :stories
    assert_response :success
  end

end
