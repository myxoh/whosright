module ConfigConstants
  VERSION=1
  
  INITIAL_CONFIG={
      lang: "en",
      title:"Who's Correct?",
      logo:"Who's Correct?",
      header: '/partials/logged_out_header',
      main_class: 'container',
      footer: nil
  }
  
  LOGGED_HEADER='/partials/default_header'
  NEW_DISCUSSIONS_TIME_DEFINITION=1
  
  protected
  def new_discussions_time_definition
     NEW_DISCUSSIONS_TIME_DEFINITION.hours.ago
  end
end