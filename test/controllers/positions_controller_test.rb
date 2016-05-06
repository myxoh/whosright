require 'test_helper'

class PositionsControllerTest < ActionController::TestCase
  setup do
    @discussion = discussions(:one)
    @discussion.update(user:User.first)
    @position = positions(:one)
    @position.update(discussion:@discussion,user:users(:two))
    @no_permissions_user=users(:three)
    log_in(users(:one))
  end
  
  test "should require to be logged in for all methods" do
    get :show, id: @position
    assert_redirected_to login_path
    assert_match(flash[:error], "log")
  end
  
  test "should not get index" do
    get :index
    assert_redirected_to root_path
    assert_match(flash[:error], "permission")
  end

  test "should get new only from specified discussion" do
    assert_raises(Exception){get :new}
    get new_discussion_position_path(@discussion)
    assert_response :success
  end

  test "should get new only from specified user" do
    assert false
  end

  test "should create position only from specified discussion" do
    assert false
    #assert_difference('Position.count') do
    #  post :create, position: { body: @position.body, discussion_id: @position.discussion_id, email: @position.email, name: @position.name, score: @position.score }
   # end
   # assert_redirected_to position_path(assigns(:position))
  end

  test "should create position only with specified params" do
    assert false
  end
  
  test "should create position only from correct user" do
    assert false
  end


  test "should get edit only for correct user" do
    assert false
  end

  test "should update position only for correct user" do
    assert false
    #patch :update, id: @position, position: { body: @position.body, discussion_id: @position.discussion_id, email: @position.email, name: @position.name, score: @position.score }
    #assert_redirected_to position_path(assigns(:position))
  end
  
  test "should update only the correct params" do
    assert false
  end

  test "should destroy only for correct users" do
    #assert_difference('Position.count', -1) do
    #  delete :destroy, id: @position
    #end

    #assert_redirected_to positions_path
    assert false
  end
end
