class Position < ActiveRecord::Base
  include Votable
  include Commentable
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format: {with: VALID_EMAIL_REGEX}
  belongs_to :discussion
  belongs_to :user, foreign_key: "email", primary_key: "email"
  validates :discussion, presence: true
  validate :discussion_not_published
  has_secure_token

  scope :active, ->{where.not(body:nil)}
  
  def new?
    body.nil? && name.nil?
  end

  def editable? remote_user
   !discussion_not_published_conditions && remote_user.owns?(self)
  end
  
  def get_name(order = id, remote_user = User.new)
    if remote_user.owns? discussion
      if user.nil?
        "Invite pending. No. #{order}"
      else
        "#{user.full_name} (#{user.email})"
      end
    else
      (!name.nil?)? name : "Person #{order}" 
    end
  end
  
  private
  def discussion_not_published
    if discussion_not_published_conditions
      errors.add(:body, "You are trying to update or create a position for an already published Discussion.")
    end
  end

  def discussion_not_published_conditions
    discussion.nil? || discussion.published?
  end
end
