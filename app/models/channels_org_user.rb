class ChannelsOrgUser < ApplicationRecord
  belongs_to :channel
  belongs_to :organizations_user
end
