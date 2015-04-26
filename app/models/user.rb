class User < ActiveRecord::Base
  # Exceptions
  class NotAuthorized < StandardError; end
  class AuthenticationRequired < StandardError; end

  # Different access levels, every level inherits the permissions
  # from the levels below.
  #   admin       may do everything (even manage users)
  #   user        may manage the inventory
  #   api-full    manage the inventory via the API
  #   api-insert  add information to the inventory via the API
  #   api-read    read only access to the inventory via the API
  ROLES= %w(admin user api-full api-insert api-read)

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #
  # Default Devise options
  # devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable
  devise :database_authenticatable, :trackable

  # :login              Virtual attribute for authenticating by either username
  #                     or email. This is in addition to a real persisted field
  #                     like 'username'
  # :current_password   Forces the user to enter the current password to update
  #                     their profile. Not required for admins though
  # :new_auth_token     If set to true a new auth token will be generated
  attr_accessor :login, :current_password, :new_token

  # generate a auth token for new users
  before_create :generate_auth_token

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :role, presence: true, inclusion: ROLES
  validates :auth_token, uniqueness: true

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      conditions[:email].downcase! if conditions[:email]
      where(conditions.to_hash).first
    end
  end

  def generate_auth_token
    begin
      self.auth_token = Devise.friendly_token
    end while User.find_by_auth_token(auth_token)
  end

  def admin?
    role?(:admin)
  end

  def role?(base_role)
    ROLES.index(base_role.to_s) >= ROLES.index(role)
  end
end
