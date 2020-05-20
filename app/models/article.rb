class Article < ApplicationRecord
  belongs_to :channel

  has_many :contents, dependent: :destroy
end
