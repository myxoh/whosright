module CommentsHelper
  def get_comments(replier)
    level = 0
    if replier.class == Comment
      level = replier.get_level
    end

    comments = replier.comments.limit(3)
    comments = replier.comments.first(1) if level != 0

    if level < 3
      render partial: 'comments/comments', locals: {comments: comments, replier: replier}
    end
  end
  
  def commentable_tag(replier)
    render partial: 'comments/commentable', locals: {reply_to: replier}
  end

  def should_display_view_all(replier)
    level = 0
    if replier.class == Comment
      level = replier.get_level
    end

    case level
      when 0
        replier.comments.count > 2 # To avoid loading the comments again or getting 4 comments unnecesary
      when 1..2
        replier.comments.count > 1
      else
        false
    end
  end
  
end
