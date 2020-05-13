class Channel < ApplicationRecord
  has_many :invites, as: :item

  has_many :channels_org_users
  has_many :organizations_users, through: :channels_org_users
  has_many :users, through: :organizations_users
  has_many :link_groups

  belongs_to :organization
end
