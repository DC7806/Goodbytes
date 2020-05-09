class OrganizationsUser < ApplicationRecord
  belongs_to :organization, dependent: :destroy
  belongs_to :user, dependent: :destroy

  validates :user, presence: true
  validates :organization, presence: true
end
