ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include SessionsHelper
  
  def log_in( user, messages = nil)
    session[:user_id]=user.id
    redirect_to home_path, flash:messages unless messages.nil? #Step over regular log_in to be able to use if for tests
  end
  
  def log_out
    session[:user_id]=nil
  end
  
     
  def not_enough_permissions_assertion(wrong_user,&local_test)
    log_in(wrong_user)
    if block_given?
      local_test.call()
    end
    assert_redirected_to root_path
    assert_match("permission",flash[:error])
  end
  
  # Add more helper methods to be used by all tests here...
end
