update_score=(model, id,score)->
  $("#score_for_"+model+"_"+id).text(score)
glow_vote_up=(model,id,glow)->
  $("#vote_glowable_down_"+model+"_"+id).removeClass("bad")
  $("#vote_glowable_up_"+model+"_"+id).toggleClass("good")
glow_vote_down=(model,id,glow)->
  $("#vote_glowable_up_"+model+"_"+id).removeClass("good")
  $("#vote_glowable_down_"+model+"_"+id).toggleClass("bad")
votable_initialize=()->
  $(".vote_up").bind "ajax:success", (evt, data, status, xhr) ->
    update_score(data.model,data.id,data.score)
    glow_vote_up(data.model,data.id,data.glow)
  $(".vote_down").bind "ajax:success", (evt, data, status, xhr) ->
    update_score(data.model,data.id,data.score)
    glow_vote_down(data.model,data.id,data.glow)
    
$(document).ready(votable_initialize);
$(document).on('page:load', votable_initialize);