class OrganizationsUser < ApplicationRecord
  belongs_to :organization
  belongs_to :user

  validates :user, presence: true
  validates :organization, presence: true
end
