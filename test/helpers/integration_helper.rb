module IntegrationHelper
  def i_log_in( user, messages = nil)
    post login_path sessions:{email:user.email,password:"password"}
    puts "Log In"
  end
  
  def i_log_out
     delete logout_path
  end
  
     
  def i_not_enough_permissions_assertion(wrong_user,&local_test)
    i_log_in(wrong_user)
    if block_given?
      local_test.call
    end
    assert_redirected_to root_path, "Didn't get redirected from #{wrong_user.inspect}"
    assert_match("permission",flash[:error], "Didn't get permission errors from #{wrong_user.inspect}")
  end
end