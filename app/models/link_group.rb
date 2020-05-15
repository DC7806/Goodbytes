class LinkGroup < ApplicationRecord
  belongs_to :channel
  has_many :saved_links
end
