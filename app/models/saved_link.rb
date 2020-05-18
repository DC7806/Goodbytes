class SavedLink < ApplicationRecord
  belongs_to :link_group

  validates :url, presence: true
  validates :subject, presence: true
end
