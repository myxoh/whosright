class SessionsController < ApplicationController
  before_action :get_user, only: [:redirect]

  def new
    initial_config
  end

  def create
    #TODO code the 'remember-me' button
    user=User.find_by_email(params[:sessions][:email])
    if user&&user.authenticate(params[:sessions][:password]) then
      log_in user, notice: "Successfully logged in"
    else
      flash.now[:error]="Wrong E-mail or Password"
      render 'new'
    end
  end

  def oauthcreate
    user = User.from_omniauth(env["omniauth.auth"])
    log_in user
    redirect_to '/home/search?email='+user.email.to_s+'&temporary_access_code='+random_string.to_s
  end

  def destroy
    session.delete(:user_id)
    #There seemed to be a bug with this, therefore I'm reinitializating the isntance
    initial_config
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