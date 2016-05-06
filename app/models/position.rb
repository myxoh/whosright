class Position < ActiveRecord::Base
  belongs_to :discussion
  belongs_to :user, foreign_key:"email",primary_key:"email"
  has_secure_token
  def get_name(order = id)
    (!name.nil?)? name : "Person #{order}" 
  end
end
