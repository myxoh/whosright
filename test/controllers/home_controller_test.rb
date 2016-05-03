require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  def  setup 
    session[:user_id]=nil
  end
  
  test "should redirect to login because user is not logged in" do
    get :stories
    assert_redirected_to login_path #Before being logged in, we cannot access this site.
    session[:user_id]=User.first.id
  end
  
end
