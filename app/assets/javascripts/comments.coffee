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
    $("#reply_to_"+$(this).data("to")).show()
    return false

  $(document).on "ajax:success", ".reply_to form", (evt, data, status, xhr)->
    container = $(this).parent().siblings(".comments") # this = form; parent = .reply_to div;
                                                       # which is a sibling of the comments container
    console.log($(this))
    container.append(data)
    container.append(container.children("small"))      #Moves view all to the end of the comments div


  $(".comments").on "ajax:success", ".view_all", (evt, data, status, xhr) ->
    comments = $(this).closest(".comments")	
   	append_this = new_comments($.parseHTML(data))
   	comments.append(append_this)
   	$(this).parent().remove()


$(document).ready(comments_initialize);
