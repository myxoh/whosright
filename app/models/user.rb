class User < ActiveRecord::Base

  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_save {self.email = email.downcase}
  validates :first_name, presence: true, length: {minimum: 2,maximum: 50}
  validates :last_name, presence: true, length: {minimum: 2,maximum: 50}
  validates :email, presence: true,
                    uniqueness: {case_sensitive: false},
                    format:{with: VALID_EMAIL_REGEX}
  validates :password, length: {minimum: 6}
  has_one :profile, class_name: "UserProfile"
  has_many :discussions
  has_many :positions, foreign_key:"email", primary_key:"email"

  def self.find_by_email(email)
    return User.find_by(email:email.downcase)
  end

  def self.from_omniauth(auth)
    if find_by(provider: auth.provider, uid: auth.uid) == find_by(email:auth.info.email)
      where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.first_name = auth.info.first_name
        user.last_name = auth.info.last_name
        user.oauth_token = auth.credentials.token
        user.oauth_expires_at = Time.at(auth.credentials.expires_at)
        user.email = auth.info.email
        user.password=(0...30).map { ('0'..'z').to_a[rand(75)] }.join
        user.save!
      end
    else
      false
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def owns?(object)
    self==object.try(:user) || self==object
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
