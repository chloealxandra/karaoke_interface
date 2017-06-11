class User < ApplicationRecord
  has_many :plays
  has_many :songs, through: :plays
  has_and_belongs_to_many :karaoke_sessions
  has_many :favorites
  has_many :songs, through: :favorites

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  # attr_accessor :email

  def self.find_for_database_authentication(warden_conditions) #added for devise login stuff: https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_hash).first
    end
  end

  validates :username,
  :presence => true,
  :uniqueness => {
    :case_sensitive => false
  }

end
