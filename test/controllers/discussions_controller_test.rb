require 'test_helper'
class DiscussionsControllerTest < ActionController::TestCase
  setup do
    @discussion = discussions(:one)
    log_in(@discussion.user) # User one
  end

  def edit_test
    get :edit, id: @discussion
  end
  
  def update_test
    patch :update, id: @discussion, discussion: { body: @discussion.body, discussion_type_id: @discussion.discussion_type_id, header: @discussion.header, score: @discussion.score, topic_id: @discussion.topic_id}
  end
    
  def destroy_test(destroy = true)
    change=(destroy)? -1 : 0
    assert_difference('Discussion.count', change) do
      delete :destroy, id: @discussion
    end
  end
  
  test "should not allow user to create with no session" do
    log_out
    assert_no_difference('Discussion.count') do
      post :create, discussion: { body: @discussion.body, discussion_type_id: @discussion.discussion_type_id, header: @discussion.header, score: @discussion.score, topic_id: @discussion.topic_id, user_id: @discussion.user_id }
    end

    assert_redirected_to login_path
    assert_match("login",flash[:error])
    log_in(users(:one))
  end
  
  test "should not get index" do #We do not want this page with no user
    assert_raises(Exception) { get :index }
  end
  
  test "Should get full index" do
    get :index, user_id: @discussion.user
    assert_response :success
    assert_equal assigns(:published).collect{|d| d.id}, @discussion.user.discussions.published.collect{|d| d.id}
    assert_equal assigns(:unpublished).collect{|d| d.id}, @discussion.user.discussions.unpublished.collect{|d| d.id}
  end
  
    test "Should get partial index" do
    get :index, user_id: users(:two)
    assert_response :success
    assert_equal assigns(:published).collect{|d| d.id}, users(:two).discussions.published.collect{|d| d.id}
    assert_nil assigns(:unpublished).try(:collect){|d| d.id}
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create discussion" do
    assert_difference('Discussion.count') do
      post :create, discussion: { body: @discussion.body, discussion_type_id: @discussion.type.id, header: @discussion.header, topic_id: @discussion.topic.id}
    end
    assert_redirected_to discussion_path(assigns(:discussion))
  end

  test "should show discussion" do
    get :show, id: @discussion
    assert_response :success
  end

  test "should get edit" do
    edit_test
    assert_response :success
  end

  test "should update discussion" do
    update_test
    assert_redirected_to discussion_path(assigns(:discussion))
  end

  test "should destroy discussion" do
    destroy_test
    assert_redirected_to discussions_path
  end
  
  test "should NOT edit" do
    not_enough_permissions_assertion(users(:two)){edit_test}
  end
  
  test "should NOT patch" do
    not_enough_permissions_assertion(users(:two)){update_test}
  end
  
  test "should NOT destroy" do
    not_enough_permissions_assertion(users(:two)){destroy_test(false)}
  end
  
  test "should allow should show positions" do
    get :show, id: @discussion
    assert !assigns(:discussion).positions.blank? #Should have the positions feeded in the test
  end
  
  test "JS search for user"  do
    #TODO Check the different interaction with the e-mail (finding an user, not finding him)
    #require_js
    #TODO CHECK that in both cases I'm allowed to invite him.
    #assert false
  end
  
  test "Validate Vote Methods" do
    vote_methods @discussion
  end
  
end
