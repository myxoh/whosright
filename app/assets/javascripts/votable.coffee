update_score=(model, id,score)->
  $("#score_for_"+model+"_"+id).text(score)
glow_vote_up=(id,glow)->
  console.log("id vote new status is: "+glow)
glow_vote_down=(id,glow)->
  console.log("id vote new status is: "+glow)
votable_initialize=()->
  $(".vote_up").bind "ajax:success", (evt, data, status, xhr) ->
    update_score(data.model,data.id,data.score)
    glow_vote_up(data.id,data.glow)
  $(".vote_down").bind "ajax:success", (evt, data, status, xhr) ->
    update_score(data.model,data.id,data.score)
    glow_vote_down(data.id,data.glow)
    
$(document).ready(votable_initialize);
$(document).on('page:load', votable_initialize);