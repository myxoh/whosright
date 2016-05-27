#Positions should be (new) created from the DISCUSSION owner
#Positions should be (edit) updated from the POSITION owner
#Positions can be destroyed by both the DISCUSSION and POSITION owner , but not by any other user.

#Position one owner: User two.
#Position one discussion: Discussion one (Which is owned by User ONE)


require 'test_helper'

class PositionsControllerTest < ActionController::TestCase
  setup do
    @position = positions(:one)
    @discussion=@position.discussion #Discussion one
    @user = users(:one)
    log_in(users(:one)) #User one - It's the Discussion owner but NOT the position owner
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
    post :create, discussion_id:discussion, position: { email: "some@email.com", body:"some body", name:"Some name"}
  end
  
  def assert_create_position(should = true, discussion = @discussion)
    difference = (should)? 1 : 0
    assert_difference('Position.count', difference) do
      create_position(discussion)
    end
    return Position.last
  end
  
  
  def new_position(discussion = @discussion)
    get :new, discussion_id:discussion
  end
  
  test "should require to be logged in for all methods" do
    log_out()
    get :show, id: @position
    assert_redirected_to login_path
    assert_match("log", flash[:error])
    log_in(@position.user)
  end
  
  test "should get index" do
    log_in @position.user
    get :index, user_id: @position.user
    assert_equal assigns(:positions).try(:collect){|p| p.id}.to_a, @position.user.positions.where(body:nil).try(:collect){|p| p.id}
    assert_response :success
  end

  test "should not get index for other users" do 
    not_enough_permissions_assertion(users(:one)){ get :index, user_id: users(:two) } #Logged In as One, Access Two.
  end
  
  test "should get new" do
    new_position
    assert_response :success
  end

  test "should get new only from specified user" do    
    not_enough_permissions_assertion(users(:two)){new_position}
    not_enough_permissions_assertion(users(:no_permissions)){new_position}
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
    assert_create_position
    
    log_in(users(:no_permissions))
    assert_create_position false
  end

  def edit_position position
    get :edit, id:position
  end
  
  test "should get edit only for correct user" do
    #For this test we're going to use the POSITION owner and not the DISCUSSION owner
    log_in(@position.user)

    edit_position @position
    assert_response :success
    not_enough_permissions_assertion(users(:one)){edit_position @position} #Read comments on top
    not_enough_permissions_assertion(users(:no_permissions)){edit_position @position}
  end
  
  def update_position position
    post :update, id:position, position:{name:"NewName",body:"NewBody",score:10,discussion_id:10,email:"get@email.com"} #Note I'm not expecting the score and the discussion_id to be updated
  end
  
  def assert_update position, correct = true
    #Since I'll get a bunch of positions in the Discussion param, it's easier to check with a reload if the position was updated correctly
    position.reload
    if correct then
      assert_equal("NewName",@position.name)
      assert_equal("NewBody",@position.body)
    else
      assert_not_equal("NewName",@position.name)
      assert_not_equal("NewBody",@position.body)
    end
    assert_not_equal(10,@position.score) # Check this param is not updatable.
    assert_not_equal(10,@position.discussion_id) # Check this param is not updatable.
  end
  
  test "should update position only for correct user and correct params" do
    #For this test we're going to use the POSITION owner and not the DISCUSSION owner
    log_in(@position.user)
    update_position @position
    assert_redirected_to discussion_path(@discussion)
    assert_update @position
  end
  test "should update position only for correct user and correct params (two)" do  
    not_enough_permissions_assertion(@discussion.user){update_position @position}
    assert_update @position, false
  end
  test "should update position only for correct user and correct params (three)" do  
    not_enough_permissions_assertion(users(:no_permissions)){update_position @position}
    assert_update @position, false 
  end
  
  def destroy_test position, correct = true
    change=(correct)? -1 : 0
    assert_difference('Position.count', change) do
      delete :destroy, id: @position
    end
  end
  
  test "should destroy from Discussion Owner" do
    destroy_test @position
  end
  
  test "should destroy from Position Owner" do
    log_in(@position.user)
    destroy_test @position
  end
  
  test "should not destroy" do
    not_enough_permissions_assertion(users(:no_permissions)){destroy_test @position, false}
  end
  

   
  test "vote_up and vote_down test" do
    vote_methods @position
  end

end
