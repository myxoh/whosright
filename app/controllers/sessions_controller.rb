class SessionsController < ApplicationController
  before_action :get_user
  helper_method :log_in
  
  def new
    
  end
  
  def create
    #TODO code the 'remember-me' button
    user=User.find_by_email(params[:sessions][:email])
    if user&&user.authenticate(params[:sessions][:password]) then
        log_in(user)
        redirect_to home_path
    else
        flash.now[:error]="Wrong E-mail or Password"
        render 'new'
    end
  end

  def destroy
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