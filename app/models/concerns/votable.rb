module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable
  end
  
  def vote_up!(user)
    votes.crud(user,self,true)
    reload
  end
  def vote_down!(user)
    votes.crud(user,self,false)
    reload
  end
end