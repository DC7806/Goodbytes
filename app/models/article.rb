class Article < ApplicationRecord
  acts_as_paranoid
  belongs_to :channel

  has_many :contents, dependent: :destroy
  
  validates :subject, presence: true
end
