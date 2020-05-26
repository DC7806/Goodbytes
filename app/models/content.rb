class Content < ApplicationRecord
  acts_as_paranoid
  belongs_to :article
  has_one :channel, through: :article
  enum layout: {
    one_title_one_desc: 0,
    one_title: 1,
    one_desc: 2
  }
end