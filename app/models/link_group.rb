class LinkGroup < ApplicationRecord
  belongs_to :channel
  has_many :saved_links, dependent: :destroy
  
  validates :name, presence: true

  # 這是link_group底下的path_params
  # 用法上會是 link_group_object.path_params
  # 別跟helper提供的path_params搞混了
  def path_params
    {
      id: id,
      channel_id: channel_id
    }
  end
end
