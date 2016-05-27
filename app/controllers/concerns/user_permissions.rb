module UserPermissions
  extend ActiveSupport::Concern
  
  def get_user_or_redirect
    get_user
    if @user.nil? then
      redirect_to login_path, flash: {error: "You must login first"} and return
    else
      logged_in_configurations()
    end
  end

  def get_user
    @user=User.find_by_id(session[:user_id])
  end

  def only_admin
    #TODO if we ever get user_types check for user_type==User::ADMIN
    redirect_to root_path, flash: {error: "Not enough permissions"}
  end

  def match_user(object, options = {})
    #Set default Options
    user=options[:to_user]
    options[:no_redirect]||=false
    get_user_or_redirect # Options 'no_redirect' refers to no redirecting if it doesn't own the object. If their is no user we want a redirect.
    user||=@user
    #Finish setting default options
    puts "SECURITY VIOLATION: User #{user.inspect} tried to access object: #{object.inspect} at #{Time.now} \n "\
    "that resource belongs to #{object.try(:user).try(:inspect)}. " unless user.owns? object

    redirect_to(root_path, flash: {error: "Not enough permissions"}) and return unless (user.owns?(object) || options[:no_redirect])
    return (user.owns? object)
  end

  def custom_conditions(conditions = false)
    redirect_to(root_path, flash: {error: "Not enough permissions"}) and return unless conditions
  end
end