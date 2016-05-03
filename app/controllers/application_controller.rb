class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :initial_config
  include SessionsHelper
  def initial_config
    @config={
      lang: "en",
      title:"Who's Right?",
      header: '/partials/not_logged',
      main_class: 'container',
      footer: nil
    }
    @user=nil
  end
  
  
  def get_user_or_redirect
    get_user
     @config[:header]='/partials/default_header'
     if @user.nil? then redirect_to login_path end
  end
  
  def get_user
    @user=User.find_by_id(session[:user_id])
  end
  
  def only_admin
    #TODO if we ever get user_types check for user_type==User.ADMIN
    redirect_to root_path, flash:{error:"Not enough permissions"}
  end
  
end
