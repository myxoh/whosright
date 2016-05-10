ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include SessionsHelper
  
  
  #TODO Make this file Modular
  
  
  #Controller Helpers (FUNCTIONAL):
  
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
    assert_redirected_to root_path, "Didn't get redirected from #{wrong_user.inspect}"
    assert_match("permission",flash[:error], "Didn't get permission errors from #{wrong_user.inspect}")
  end
  
  def vote_assertion new_score, element
    assert_response :success
    element.reload
    element_assigns=assigns(:position)||assigns(:discussion) #Not really nice way of doing this.
    element_json=JSON.parse(@response.body)
    assert_equal new_score, element_assigns.score
    assert_equal element_assigns.score, element.score
    assert_equal element.score, element_json["score"]
    assert_equal element_json["class"], element["class"]
  end
  
  
  def vote_methods element
    #First time should update the score +1 (1)
    old_score=element.score
    get :vote_up, id:element
    vote_assertion old_score+1, element
    
    #Vote down should now update the score -2 (-1)
    get :vote_down, id:element
    vote_assertion old_score-1, element
    
    #Vote down again should update the score +1 (0)
    get :vote_down, id:element
    vote_assertion old_score, element
    
    #Vote down again should update the score -1 (-1)
    get :vote_down, id:element
    vote_assertion old_score-1, element
    
    #Vote up should update the score +2         (+1)
    get :vote_up, id:element
    vote_assertion old_score+1, element
    
    #Finally vote up again should restore the score
    get :vote_up, id:element
    vote_assertion old_score, element
  end
  
  #Model Helpers (UNIT)
  
  def global_remove_param_test( param, element, should = true ) #Implement should
      old_param=element.send(param)
      element.send("#{param}=",nil)
      assert_not element.valid?
      element.send("#{param}=",old_param)
  end
  
  def global_too_short_param( param, length, element) #Implement should
    element[param]="a"*(length)
    assert element.valid?, "#{param}  wasn't Less than the minimum (#{length})"
    element[param]="a"*(length-1)
    assert_not element.valid?, "#{param}  was Less than the minimum (#{length})"
  end
  
  def global_too_long_param( param, length, element )
    element[param]="a"*(length)
    assert element.valid?, "#{param} was more than the maximum (#{length})"
    element[param]="a"*(length+1)
    assert_not element.valid?, "#{param}  wasn't more than the maximum (#{length})"
  end
  
  def validate_votes element
    user=User.first
    element.score=0
    element.save
    element.vote_up! user
    assert_equal element.score, 1
    element.vote_down! user
    assert_equal element.score, -1
    element.vote_down! user
    assert_equal element.score, 0
    element.vote_up! user
    element.vote_up! user
    assert_equal element.score, 0
  end
  
  # Add more helper methods to be used by all tests here...
end
