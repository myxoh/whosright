require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    log_in(users(:one)) #Logged in as the second user.
    @user = users(:one) #
  end
  
  def edit_test
    get :edit, id: @user
  end
  
  def update_test
    patch :update, id: @user, user: {first_name: "Nicolas",last_name:"Klein", email:"valid@email.com", password:"123test",password_confirmation:"123test"}
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
    not_enough_permissions_assertion(users(:two)){edit_test}
  end

  test "should get edit" do
    edit_test
    assert_response :success
  end
  
  test "should not update user" do
     not_enough_permissions_assertion(users(:two)){update_test}
  end

  test "should update user" do
    update_test
    assert_redirected_to user_path(assigns(:user)), "With user:#{@user.email}"   
    assert_not_equal assigns(:user).email, "valid@email.com", "Email changed! Email should NOT be changed"
  end

  test "should not destroy user" do
    assert_difference('User.count', 0) do
      delete :destroy, id: @user
    end
    assert_redirected_to root_path
  end
  
  test "Search tests" do
    user=users(:two)
    get :by_email, user:{email: user.email}
    assert_response :success
    assert_equal assigns(:requested_user), user
    
    get :by_email, user:{email: user.email}, format: 'json'
    assert_response :success
    
    assert_raises(Exception){get :by_email, user:{email: "invalid@user.email"}}
  end
  
  test "Positions tests" do
    get :positions, id:@user
    assert_equal assigns(:positions), @user.positions.where(body:nil)
    
  end
  
  
end
