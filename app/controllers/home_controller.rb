class HomeController < ApplicationController
  before_action :get_user_or_redirect
  def stories
    @discussions=Discussion.published
  end
end
