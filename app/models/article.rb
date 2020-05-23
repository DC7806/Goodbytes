class Article < ApplicationRecord
  acts_as_paranoid
  belongs_to :channel

  has_many :contents, dependent: :destroy
end
