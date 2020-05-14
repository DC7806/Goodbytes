class OrganizationsUser < ApplicationRecord
  has_many :channels_org_users, dependent: :destroy
  has_many :channels, through: :channels_org_users

  belongs_to :organization
  belongs_to :user

  validates :user, presence: true
  validates :organization, presence: true
end
