# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

email=""
set_result = (key, user)->
  ur="user_result_"
  $("#"+ur+key).text(user[key])

user_found = (user)->  
  #Explicitely set the param
  $("#user-box").show()
  $("#invite-box").hide()
  email=user.email
  set_result('link',user)
  set_result('full_name',user)
  set_result('email',user)
  
invite_user = ()->
  window.location.href=route+"?email="+email
  
no_user_found = ->
  $("#user-box").hide()
  $("#invite-box").show()
  email=$("input[type='email']").val()
  $("b[data-param='email']").text $("input[type='email']").val() # User not found
  $("span[data-param='email']").text $("input[type='email']").val() # User not found

ready = -> 
  $("#user-box").hide()
  $("#invite-box").hide()
  $("#search_form").bind "ajax:success", (evt, data, status, xhr) ->
    user_found(data)
  $("#search_form").bind "ajax:error", (xhr, status, error) ->
    no_user_found()
  $(".invite_link").bind "click", ()-> 
    return invite_user()
  
$(document).ready(ready);
$(document).on('page:load', ready);

    
