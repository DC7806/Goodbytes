class SavedLink < ApplicationRecord
  belongs_to :link_group
  has_one :channel, through: :link_group

  validates :url, presence: true
  validates :subject, presence: true

end
