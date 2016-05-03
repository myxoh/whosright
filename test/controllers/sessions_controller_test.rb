require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  def setup
    User.create(email:"test@email.com",first_name:"Juan",last_name:"Carlos",password:"test123")
  end
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
    assert_response :success
    assert_match "Wrong E-mail or Password", flash[:error]
    
  end

  test "should get redirected to login" do
    get :redirect
    assert_redirected_to login_path
  end
  
  test "shoud log in succesfully" do
    post :create, sessions:{email:"test@email.com",password:"test123"}
    assert_redirected_to home_path
  end
end
