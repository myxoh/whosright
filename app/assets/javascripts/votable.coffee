update_score=(model, id,score)->
  $("#score_for_"+model+"_"+id).text(score)
glow_vote_up=(model,id,glow)->
  $("#vote_glowable_down_"+model+"_"+id).removeClass("bad")
  $("#vote_glowable_up_"+model+"_"+id).toggleClass("good")
glow_vote_down=(model,id,glow)->
  $("#vote_glowable_up_"+model+"_"+id).removeClass("good")
  $("#vote_glowable_down_"+model+"_"+id).toggleClass("bad")
  
vote_up = (evt, data, status, xhr) ->
  update_score(data.model,data.id,data.score)
  glow_vote_up(data.model,data.id,data.glow)
    
vote_down = (evt, data, status, xhr) ->
  update_score(data.model,data.id,data.score)
  glow_vote_down(data.model,data.id,data.glow) 
  
votable_initialize=()->
  $(document).on "ajax:success", ".vote_up", vote_up
  $(document).on "ajax:success", ".vote_down", vote_down
    
$(document).ready(votable_initialize);