class LinkGroup < ApplicationRecord
  belongs_to :channel
  has_many :saved_links, dependent: :destroy
  
  validates :name, presence: true

  def path_params
    {
      id: id,
      channel_id: channel_id
    }
  end
end
