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
  
  def vote_up path
    link_to span("",class:"glyphicon glyphicon glyphicon-thumbs-up"), path, remote:true, class:"btn btn-success vote_up"
  end
  
  def vote_down path
    link_to span("",class:"glyphicon glyphicon glyphicon-thumbs-down"), path, remote:true, class:"btn btn-danger vote_down"
  end
end