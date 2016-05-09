module ConfigConstants
  VERSION=2
  NEW_DISCUSSIONS_TIME_DEFINITION=1
  
  def initial_settings()
  {
      lang:"en",
      title:"Who's Correct?",
      logo:"Who's Correct?",
      header:"/partials/logged_out_header",
      main_class:"container",
      footer: nil
  }
  end
  
  def logged_header()
    "/partials/default_header"
  end
  
  
  protected
  def new_discussions_time_definition
     NEW_DISCUSSIONS_TIME_DEFINITION.hours.ago
  end
end