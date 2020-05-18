class LinkGroup < ApplicationRecord
  belongs_to :channel
  has_many :saved_links, dependent: :delete
  
  validates :name, presence: true
end
