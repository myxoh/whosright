class Position < ActiveRecord::Base
  include Votable
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format:{with: VALID_EMAIL_REGEX}
  belongs_to :discussion
  belongs_to :user, foreign_key:"email",primary_key:"email"
  validates :discussion, presence:true
  validate :discussion_not_published
  has_secure_token
  def get_name(order = id, user = User.new)
    if user.owns? discussion
      "#{user.full_name} (#{user.email})"
    else
      (!name.nil?)? name : "Person #{order}" 
    end
    
  end
  def discussion_not_published
    if discussion.nil?||discussion.published?
      errors.add(:body,"You are trying to update or create a position for an already published Discussion.")
    end
  end
end
