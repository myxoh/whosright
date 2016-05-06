require 'test_helper'

class DiscussionTest < ActiveSupport::TestCase
  def setup
    @discussion = Discussion.new(user:User.first,header:"string",body:"string\nstring",topic:Topic.first,type:DiscussionType.first)
  end


  def remove_param_test( param, discussion = @discussion )
    old_param=discussion.send(param)
    discussion.send("#{param}=",nil)
    assert_not discussion.valid?
    discussion.send("#{param}=",old_param)
  end
  
  def too_short_param( param, length, discussion = @discussion )
    discussion[param]="a"*(length)
    assert discussion.valid?, "#{param}  wasn't Less than the minimum (#{length})"
    discussion[param]="a"*(length-1)
    assert_not discussion.valid?, "#{param}  was Less than the minimum (#{length})"
  end
  
  def too_long_param( param, length, discussion = @discussion )
    discussion[param]="a"*(length)
    assert discussion.valid?, "#{param} was more than the maximum (#{length})"
    discussion[param]="a"*(length+1)
    assert_not discussion.valid?, "#{param}  wasn't more than the maximum (#{length})"
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
