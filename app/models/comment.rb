class Comment < ActiveRecord::Base
  include Votable
  include Commentable
  
  belongs_to :user
  belongs_to :to, polymorphic: true
  
  def get_level
    level = 1
    parent = self.to
    while parent.class == Comment do
      level += 1
      parent = parent.try(:to)
    end
    level
  end
  
  def container
    parent = self.to
    while parent.class == Comment do
      parent = parent.try(:to)
    end
    parent
  end
  
end
