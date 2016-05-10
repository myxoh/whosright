require 'test_helper'

class DiscussionTest < ActiveSupport::TestCase
  def setup
    @discussion = Discussion.new(user:User.first,header:"string",body:"string\nstring",topic:Topic.first,type:DiscussionType.first)
  end


  def remove_param_test( param, discussion = @discussion )
    global_remove_param_test param, discussion
  end
  
  def too_long_param( param, discussion = @discussion)
    global_too_long_param( param, discussion)
  end
  
  def too_short_param( param, discussion = @discussion)
    global_too_short_param( param, discussion)
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
  
end
