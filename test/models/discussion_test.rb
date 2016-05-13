require 'test_helper'

class DiscussionTest < ActiveSupport::TestCase
  def setup
    @discussion = Discussion.new(user:User.first,header:"string",body:"string\nstring",topic:Topic.first,type:DiscussionType.first)
  end


  def remove_param_test( param, discussion = @discussion )
    global_remove_param_test param, discussion
  end
  
  def too_long_param( param, length,  discussion = @discussion)
    global_too_long_param( param, length, discussion)
  end
  
  def too_short_param( param, length, discussion = @discussion)
    global_too_short_param( param, length, discussion)
  end
  
  test "should be valid" do
    assert @discussion.valid?
  end
  
  test "Validators:" do
    remove_param_test("user")
    remove_param_test("header")
    remove_param_test("topic")
    remove_param_test("type")
    too_short_param(:header,5)
    too_long_param(:header,50)
  end
  
  test "validate votes" do
    validate_votes @discussion
  end
  
  test "publish! (don't allow editing anymore)" do
    @discussion.publish!
    assert_not_nil @discussion.id, "Discussion wasn't saved"
    assert_equal @discussion.published, true, "Discussion wasn't published"
    assert_not @discussion.valid?, "Discussion shouldn't be saveable"
  end
  
  
  
  test "self.published" do
    assert_equal Discussion.published, Discussion.where(published:true)
  end
  
  
end
