class Organization < ApplicationRecord
  #associations
  has_many :organizations_users
  has_many :users, through: :organizations_users
  
  #validations
  validates :name, presence: true, uniqueness: true, length: { minimum: 1, maximum: 100 }
end
