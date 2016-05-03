class SessionsController < ApplicationController
  before_action :get_user
  def new
    @config[:header]='/partials/logged_out_header'
  end
  
  def create
    @config[:header]='/partials/logged_out_header'
    #TODO code the 'remember-me' button
    user=User.find_by_email(params[:sessions][:email])
    if user&&user.authenticate(params[:sessions][:password]) then
        log_in(user, message:"Successfully logged in")
    else
        flash.now[:error]="Wrong E-mail or Password"
        render 'new'
    end
  end

  def destroy
    session[:user_id]=nil
    redirect_to login_path
  end

  def redirect
    if @user.nil?
      redirect_to login_path
    else
      redirect_to home_path
    end
  end
end