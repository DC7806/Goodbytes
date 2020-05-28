class ChannelsOrgUser < ApplicationRecord
  belongs_to :channel
  belongs_to :organizations_user
  has_one :user, through: :organizations_user
end
