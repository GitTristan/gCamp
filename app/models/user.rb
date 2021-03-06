class User < ActiveRecord::Base

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, uniqueness: true, presence: true

  has_secure_password

  has_many :memberships, dependent: :destroy
  has_many :projects, through: :memberships

  def full_name
    "#{first_name} #{last_name}"
  end

  def project_member_verify(project)
    self.memberships.find_by(project_id: project.id) != nil
  end

  def project_owner_verify(project)
    self.admin || self.memberships.find_by(project_id: project.id).role == "Owner"
  end

  def project_member_of(user)
    user.projects.map(&:users).flatten.include?(self)
  end


end
