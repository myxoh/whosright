class Position < ActiveRecord::Base
  include Votable
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format:{with: VALID_EMAIL_REGEX}
  belongs_to :discussion
  belongs_to :user, foreign_key:"email",primary_key:"email"
  has_secure_token
  def get_name(order = id)
    (!name.nil?)? name : "Person #{order}" 
  end
end
