class User < ActiveRecord::Base
  has_secure_password
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_save { self.email = email.downcase }
  validates :first_name, presence: true, length:{minimum:2,maximum:50}
  validates :last_name, presence: true, length:{minimum:2,maximum:50}
  validates :email, presence: true,
                    uniqueness: {case_sensitive: false}, 
                    format:{with: VALID_EMAIL_REGEX}
 validates :password, length: { minimum: 6 }
  def self.find_by_email(email)
    return User.find_by(email:email.downcase)
  end
  
  def full_name
    return "#{self.first_name} #{self.last_name}"
  end
  
end
