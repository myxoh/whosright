module CommentsHelper
  def get_comments(replier)
    level = 0
    if replier.class == Comment
      level = replier.get_level
    end

    comments = replier.comments
    comments = replier.comments.first(1) if level != 0

    if level < 3
      render partial: 'comments/comments', locals: {comments: comments, replier: replier}
    end
  end
  
  def commentable_tag(replier)
    render partial: 'comments/commentable', locals: {reply_to: replier}
  end
  
end
