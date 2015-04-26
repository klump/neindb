class User < ActiveRecord::Base
  # Different access levels, every level inherits the permissions
  # from the levels below.
  #   read - only read operations are allowed
  #   insert - like read but with permissions to enter new data
  #   full - like insert but with permissions to delete objects
  #   admin - like full but may do everything (user mangement etc)
  PERMISSIONS = {
    admin: %w(admin full insert read),
    full: %w(full insert read),
    insert: %w(insert read),
    read: %w(read)
  }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #
  # Default Devise options
  # devise :database_authenticatable, :registerable,
  #       :recoverable, :rememberable, :trackable, :validatable
  devise :database_authenticatable, :trackable

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :access, presence: true, inclusion: ACCESS

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      conditions[:email].downcase! if conditions[:email]
      where(conditions.to_hash).first
    end
  end

  def admin?
    sufficient_access :admin
  end
end
