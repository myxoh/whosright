require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    user = users(:two)
    session[:user_id]=user.id #Logged in as the second user.
  end

  test "should not get index" do #Only for Admins
    get :index
    assert_redirected_to root_path
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: {first_name: "Nicolas",last_name:"Klein", email:"test_user_controller@user.com",password:"123test",password_confirmation:"123test"}
    end
    assert_redirected_to home_path
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should not get edit" do
    get :edit, id: @user
    assert_redirected_to root_path #Logged in as second user, requesting for first
  end

  test "should get edit" do
    user=users(:two)
    get :edit, id: user
    assert_response :success
  end
  
  test "should not update user" do
    patch :update, id: @user, user: {first_name: "Nicolas",last_name:"Klein", email:"valid@email.com", password:"123test",password_confirmation:"123test"}
    assert_redirected_to root_path, "Managed to update wrong user:#{@user.email}"
  end

  test "should update user" do
    user=users(:two)
    patch :update, id: user, user: {first_name: "Nicolas",last_name:"Klein", password:"123test",password_confirmation:"123test"}
    assert_redirected_to user_path(assigns(:user)), "With user:#{@user.email}"
  end

  test "should not destroy user" do
    assert_difference('User.count', 0) do
      delete :destroy, id: @user
    end
    assert_redirected_to root_path
  end
end
