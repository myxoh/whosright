require 'test_helper'

class PositionsControllerTest < ActionController::TestCase
  setup do
    @position = positions(:one)
    @discussion=@position.discussion #Discussion one
    @no_permissions_user=users(:no_permissions)
    log_in(@position.user) #User one
  end
  
  
  # => DO TO BUGS FOUND ON http://stackoverflow.com/questions/24209915/rails-functional-test-sending-url-query-parameters-in-post-request
  # => I ended up moving much of the testing to the integration test: PositionsIntegrationTest
  
  test "should require to be logged in for all methods" do
    log_out()
    get :show, id: @position
    assert_redirected_to login_path
    assert_match("log", flash[:error])
    log_in(@position.user)
  end
  
  test "should not get index" do
    get :index
    assert_redirected_to root_path
    assert_match("permission",flash[:error])
  end

end
