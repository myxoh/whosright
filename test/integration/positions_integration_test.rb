require 'test_helper'
require 'helpers/integration_helper'
include IntegrationHelper

class PositionsIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    @position = positions(:one)
    @discussion=@position.discussion #Discussion one
    @no_permissions_user=users(:no_permissions)
    post login_path sessions:{email:users(:one).email,password:"password"}
  end
  
  
  def test_verification test_name = "", discussion = @discussion
    puts "STARTING __" +test_name
    puts "Discussion User"
    puts discussion.user.inspect
    puts "Logged in:"
    puts User.find(session[:user_id]).inspect
    puts "Flash:"
    puts flash.inspect
    puts test_name+" Ends here "
  end
   def create_position(discussion = @discussion)
    post discussion_positions_path(discussion), position: { email: "some@email.com", body:"some body", name:"Some name"}
  end
  
  def assert_create_position(should = true, discussion = @discussion)
    difference = (should)? 1 : 0
    assert_difference('Position.count', difference) do
      create_position(discussion)
    end
    return Position.last
  end
  
  def new_position(discussion = @discussion)
    get new_discussion_position_path(discussion)
  end
  
  test "should get new" do
    new_position
    assert_response :success
  end

  test "should get new only from specified user" do    
    i_not_enough_permissions_assertion(users(:two)){new_position}
    i_not_enough_permissions_assertion(users(:no_permissions)){new_position}
    i_log_in(users(:one))
   end


  test "should create position only with specified params" do
    position_created=assert_create_position
    
    assert position_created.name.nil?
    assert position_created.body.nil?
    assert position_created.score.nil?
    assert_not position_created.email.nil?
    assert_not position_created.discussion.nil?
  end
  
  test "should create position only from correct user" do
    i_log_in(users(:one)) 
    assert_create_position
    
    i_log_in(users(:no_permissions))
    assert_create_position false
    
    i_log_in(users(:one))
    
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
