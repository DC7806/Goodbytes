class Organization < ApplicationRecord
  #associations
  has_many :user_organization_refs
  has_many :user, through: :user_organization_refs

  #validations
  validates :name, presence: true, uniqueness: true, length: { minimum: 1, maximum: 100 }
  validates :user, presence: true
end
