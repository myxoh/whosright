class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :initial_config
  include SessionsHelper
  include ConfigConstants
  include UserPermissions

  def initial_config
    @config =initial_settings
    @user=nil
  end

  def logged_in_configurations
    @config[:header]=logged_header
    discussions=Discussion.where("created_at >'#{new_discussions_time_definition}'").count #new_discussions_time_definition defined in ConfigConstants
    @config[:discussions]=(discussions>99) ? "99+" : discussions
    invitations=@user.positions.where(body: nil)
    @config[:invitations]=invitations.count
  end

end
