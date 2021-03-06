class Discussion < ActiveRecord::Base
  include Votable
  include Commentable
  
  belongs_to :user
  belongs_to :topic
  belongs_to :type, class_name:"DiscussionType", foreign_key:"discussion_type_id"
  has_many :positions
  has_many :active_positions, ->{active}, class_name:"Position"

  validates :header, presence: true, length:{minimum:5,maximum:50}
  validates :user, presence: true
  validates :topic, presence: true
  validates :type, presence: true
  validates :published, absence: { message: " Problem: Discussion is already published" }
  default_scope {(order(created_at: :desc))}
  scope :published, ->{where(published: true)}
  scope :unpublished, ->{where(published: nil)}
  def editable?(user)
    user.owns?(self)&&editable_conditions?
  end

  #Just in case
  def publish_without_saving
    update_attribute(:published,true)
  end

  def publish!
    save
    update_attribute(:published,true)
  end

  private

  def editable_conditions?
    !id.nil? && !published
  end
end
