# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
new_comments = (comments)->
  new_comment = []
  $(comments).children(".comment_container").each (key, obj)->
    id = $(obj).attr("id")
    if(!document.getElementById(id))
      new_comment.push($(obj).parent())
  return new_comment
comments_initialize = ()->

  $(".comments").on "click", ".reply_link", ()-> 
    console.log("hello")
    $("#reply_to_"+$(this).data("to")).show()
    return false
    
  $(".view_all").bind "ajax:success", (evt, data, status, xhr) ->
    comments = $(this).closest(".comments")	
   	append_this = new_comments($.parseHTML(data))
   	comments.append(append_this)
   	comments.append($(this).parent())

$(document).ready(comments_initialize);
