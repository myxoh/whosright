module SessionsHelper
  def log_in(user)
    session[:user_id]=user.id
    @user=user
  end
end
