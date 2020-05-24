class Content < ApplicationRecord
  acts_as_paranoid
  belongs_to :article
  has_one :channel, through: :article
end