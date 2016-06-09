class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user
  before_create :create_score
  before_destroy :restore_score
  before_update :change_score
  validates :user, presence:true
  validates :votable, presence:true
  validates_inclusion_of :positive, presence:true, :in => [true, false]
  def create_score
    if Vote.find_by(user: user, votable: votable).nil?
      change = (positive)? 1 : -1
      votable.update_attribute(:score,votable.score.to_i+change)
    else
      false
    end
  end

  def restore_score
    restore = (positive)? -1 : 1
    votable.update_attribute(:score,votable.score+restore) unless votable.nil?
  end

  def change_score
    change = (positive)? 2 : -2
    votable.update_attribute(:score,votable.score+change)
  end

  def self.casted(params={})
    syms=[:user,:votable]
    sanitized_params=params.select{|k,v| syms.include? k}
    return Vote.find_by(sanitized_params)
  end

  def self.casted?(params={})
    return !self.casted(params).nil?
  end

  def self.casted_up?(params={})
    self.casted(params).try(:positive)
  end

  def self.casted_down?(params={})
    self.casted(params).try(:positive) == false
  end

  def self.crud(user,votable,positive) #Technically just a "CUD"
    #TODO see what to return.
    vote=self.find_by(user:user,votable:votable) # Looks if the vote was cast.
    if vote.nil?
      self.create(user:user,votable:votable,positive:positive)
    elsif vote.positive==positive
    vote.destroy #If user re-selects the option he's therefore deleting the vote.
    else
      vote.update(positive:positive) #If user selects the other option he's updating his vote.
    end
  end

end
