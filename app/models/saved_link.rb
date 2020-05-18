class SavedLink < ApplicationRecord
  belongs_to :link_group ,dependent: :delete

  validates :url, presence: true
  validates :subject, presence: true
end
