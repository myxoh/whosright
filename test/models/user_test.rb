require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = User.new(first_name: "Nicolas",last_name:"Klein", email:"test_user_test@user.com",password:"123test",password_confirmation:"123test")
  end

  test "should be valid" do
    assert @user.valid?
  end
  
  test "should be invalid - email" do
    @user.email = "duplicate@email.com"
    @user.save
    @user=@user.dup
    
    invalid_emails = %w[mail1@hotmail,com mail2 juanito.com juanico@lacra. @.com duplicate@email.com]
    invalid_emails.each do |invalid_email|
      @user.email = invalid_email
      assert_not @user.valid?, "#{invalid_email.inspect} should be invalid"
    end
  end
  
  test "should be valid - email" do
    valid_emails = %w[a@b.c nicoklein10@hOtmAil.COM chori@pan.or]
    valid_emails.each do |valid_email|
      @user.email = valid_email
      assert @user.valid?, "#{valid_email.inspect} should be invalid"
    end
  end
  
  test "should ve invalid - password too short" do
    pass=(1..5).to_a.join
    @user.password_confirmation=@user.password=pass
    assert !@user.valid?, "Created an user with a password that's too short"
  end

end
