module VotableHelper
  def votable_tag votable
    #Ugly code starts here:
      #TODO figure out a cleaner way to do this
      path_up_helper="vote_up_"+votable.class.name.underscore+"_path"
      path_up_helper=path_up_helper.to_sym
      
      path_down_helper="vote_down_"+votable.class.name.underscore+"_path"
      path_down_helper=path_down_helper.to_sym
      #End TODO
    #Ugly code ends here
    
    path_up = method(path_up_helper).call(votable)
    path_down = method(path_down_helper).call(votable)
    render partial:"partials/votable", locals:{path_up:path_up,path_down:path_down, votable:votable}
  end
  
  def vote_up path, votable = nil, user = nil
    custom_class="glow"
    custom_class+=(Vote.casted_up?(votable:votable, user:user))? " good" : ""
    button=link_to span("",class:"glyphicon glyphicon glyphicon-thumbs-up"), path, remote:true, class:"btn btn-success vote_up"
    content_tag(:div, button, class:custom_class, id:"vote_glowable_up_"+votable.class.name+"_"+votable.id.to_s)
  end
  
  def vote_down path, votable = nil, user = nil
    custom_class="glow"
    custom_class+=(Vote.casted_down?(votable:votable, user:user))? " bad" : ""
    button=link_to span("",class:"glyphicon glyphicon glyphicon-thumbs-down"), path, remote:true, class:"btn btn-danger vote_down"
    content_tag(:div, button, class:custom_class, id:"vote_glowable_down_"+votable.class.name+"_"+votable.id.to_s)
  end
end