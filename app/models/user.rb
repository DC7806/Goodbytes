class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  #associations
  has_many :user_organization_refs
  has_many :organization, through: :user_organization_refs

  #validations
  validates :email, presence: true, uniqueness: true, length: { minimum: 1, maximum: 100 }
  validates :encrypted_password, presence: true, length: { minimum: 1, maximum: 100 }
end
