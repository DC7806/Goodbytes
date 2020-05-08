class Organization < ApplicationRecord
  #associations
  has_many :user_organization_refs
  has_many :users, through: :user_organization_refs
end
