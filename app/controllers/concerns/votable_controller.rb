module VotableController
  extend ActiveSupport::Concern
  
  included do
    before_action :get_user_or_redirect, only: [:vote_up, :vote_down]
    before_action :set_votable, only: [:vote_up, :vote_down]
  end
  
  def vote_up
    @votable.vote_up!(@user)
    render json: return_params(@votable)
  end
  
  def vote_down
    @votable.vote_down!(@user)
    render json: return_params(@votable)
  end
  
  private
  def return_params(votable)
    votable.attributes.select { |key, value| (%w"id score").include? key }.to_a.push(["model", votable.class.name]).to_h
  end
end