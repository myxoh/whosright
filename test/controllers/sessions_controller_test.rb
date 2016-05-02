require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get logout" do
    get :destroy
    assert_redirected_to login_path
  end

  test "should get redirected to login with user errors" do
    post :create, sessions:{email:"fake@email"}
    assert_redirected_to login_path
  end

  test "should get redirected to login" do
    get :redirect
    assert_redirected_to login_path
    
  end
end
