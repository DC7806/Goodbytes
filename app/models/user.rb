class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, password_length: 8..100
  
  #associations
  has_many :user_organization_refs
  has_many :organizations, through: :user_organization_refs

  #validations
  validates :email, presence: true, uniqueness: true, length: { maximum: 100 },
            format: /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
  # validates :encrypted_password, presence: true, length: { minimum: 1, maximum: 100 }
end
