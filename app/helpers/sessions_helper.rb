module SessionsHelper
  def log_in( user, messages = nil)
    session[:user_id]=user.id
    @user=user
    redirect_to home_path, flash:messages
  end
end
