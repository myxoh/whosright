require 'test_helper'
require 'helpers/integration_helper'
include IntegrationHelper

class PositionsIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    @position = positions(:one)
    @discussion=@position.discussion #Discussion one
    @no_permissions_user=users(:no_permissions)
    post login_path sessions:{email:users(:one).email,password:"password"}
  end
  
  

end
