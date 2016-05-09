class Discussion < ActiveRecord::Base
  include Votable
  belongs_to :user
  belongs_to :topic
  belongs_to :type, class_name:"DiscussionType", foreign_key:"discussion_type_id"
  validates :header, presence: true, length:{minimum:5,maximum:50}
  validates :user, presence: true
  validates :topic, presence: true
  validates :type, presence: true
  has_many :positions
  def editable? user
    user.owns?(self)&&editable_conditions?
  end
  
  private
  def editable_conditions?
    !self.id.nil?&&self.score.to_i<5
  end
end
