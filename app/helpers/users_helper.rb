module UsersHelper
  def link_to_user(user = @user, options = {})
    options[:class]||="user_link"
    link_to(user.full_name, user, options)
  end
  
  def owns?(object)
    @user.owns?(object)
  end
  
  def editable?(object)
    !!object.try(:editable?,@user)
  end
end
