class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable
  
  #associations
  has_many :organizations_users, dependent: :destroy
  has_many :organizations, through: :organizations_users
  has_many :send_invites, class_name: "Invite", foreign_key: "sender_id"
  
  #validations
  validates :email, presence: true, uniqueness: true, length: { minimum: 1, maximum: 100 }
  validates :encrypted_password, presence: true, length: { minimum: 6, maximum: 128 }

  attr_accessor :role
  
  def organizations_with_purview
    result = Organization.find_by_sql("
        select org.*,rel.role
        from organizations org
        inner join organizations_users rel
        on org.id=rel.organization_id 
        inner join users
        on users.id=rel.user_id 
        where users.id=#{id}
      ")
      result.each do |organization|
        organization.purview = organization.attributes["role"]
      end
      return result
  end
end
