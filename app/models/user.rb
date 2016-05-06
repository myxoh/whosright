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
 has_one :profile, class_name:"UserProfile"
 has_many :discussions
 has_many :positions, foreign_key:"email",primary_key:"email"
  def self.find_by_email(email)
    return User.find_by(email:email.downcase)
  end
  
  def full_name
    return "#{first_name} #{last_name}"
  end
  
  def owns?(object)
    return self==object.try(:user)
  end
  
  def as_json(options={}) #Prevent key attributes to be sent in the JSON
    {
      :id => id,
      :first_name => first_name,
      :last_name => last_name,
      :full_name => full_name,
      :email => email
    }
  end
  
end
