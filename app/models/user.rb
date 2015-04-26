class User < ActiveRecord::Base
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

  # :login  Virtual attribute for authenticating by either username or email
  #         This is in addition to a real persisted field like 'username'
  # :current_password   Forces the user to enter the current password to update
  #                     their profile. Not required for admins though
  attr_accessor :login, :current_password

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :role, presence: true, inclusion: ROLES

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      conditions[:email].downcase! if conditions[:email]
      where(conditions.to_hash).first
    end
  end

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLEX.index(role)
  end
end
