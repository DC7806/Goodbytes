class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable
  
  #associations
  has_many :organizations_users, dependent: :destroy
  has_many :organizations, through: :organizations_users
  
  #validations
  validates :email, presence: true, uniqueness: true, length: { minimum: 1, maximum: 100 }
  validates :encrypted_password, presence: true, length: { minimum: 6, maximum: 128 }
end
