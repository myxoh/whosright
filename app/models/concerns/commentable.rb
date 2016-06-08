module Commentable
  extend ActiveSupport::Concern
  included do
    has_many :comments, ->{limit(3)}, as: :to
    has_many :all_comments, class_name: 'Comment', as: :to
    
    def has_more_comments
      if self.class == Comment
        self.comments.count > 1
      else
        self.comments.count > 2 #Note if there are exactly 3 comments the view all won't return anything but this is better than making a query to check the total comments count.
      end
    end
  end
end