class User < ActiveRecord::Base
  class Unauthorized < StandardError; end
  class Forbidden < StandardError; end

  # Different access levels, every level inherits the permissions
  # from the levels below.
  #   api-read    read only access to the inventory via the API
  #   api-insert  add information to the inventory via the API
  #   api-full    manage the inventory via the API
  #   user        may manage the inventory
  #   admin       may do everything (even manage users)
  ROLES = %w(api-read api-insert api-full user admin)

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
      self.auth_token = Base64.urlsafe_encode64(Digest::SHA512.digest('nein-db' + Kernel.srand.to_s))
    end while User.find_by_auth_token(auth_token)
  end

  def admin?
    role?(:admin)
  end

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end
end
