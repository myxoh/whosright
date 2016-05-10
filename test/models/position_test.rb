require 'test_helper'

class PositionTest < ActiveSupport::TestCase
  setup do
    @position=Position.new(discussion:Discussion.last,user:User.last, name:"myText",body:"myBody",score:0)
  end
  
  
  #TODO DRY email validators
  test "validate email" do
    invalid_emails = %w[mail1@hotmail,com mail2 juanito.com juanico@lacra. @.com]
    invalid_emails.each do |invalid_email|
      @position.email = invalid_email
      assert_not @position.valid?, "#{invalid_email.inspect} should be invalid"
    end
  end
  
  test "should be valid - email" do
    valid_emails = %w[a@b.c nicoklein10@hOtmAil.COM chori@pan.or]
    valid_emails.each do |valid_email|
      @position.email = valid_email
      assert @position.valid?, "#{valid_email.inspect} should be invalid"
    end
  end
  

  
  test "validate votes" do
    validate_votes @position
  end
  
  
end
