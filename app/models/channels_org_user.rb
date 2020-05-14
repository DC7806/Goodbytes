class ChannelsOrgUser < ApplicationRecord
  belongs_to :channel
  belongs_to :user, foreign_key: :organizations_user_id
end
