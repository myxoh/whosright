require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  def  setup 
    log_in(users(:one))
  end
  
  test "should redirect to login because user is not logged in" do
    log_out()
    get :stories
    assert_redirected_to login_path #Before being logged in, we cannot access this site.
    log_in(users(:one))
  end
  
  test "should have Valid stories" do
    
  end
  
end
