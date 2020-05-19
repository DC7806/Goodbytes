class SavedLink < ApplicationRecord
  belongs_to :link_group

  validates :url, presence: true
  validates :subject, presence: true

  # 這是saved_link底下的path_params
  # 用法上會是 saved_link_object.path_params
  # 別跟helper提供的path_params搞混了
  def path_params
    {
      id: id,
      link_group_id: link_group_id
    }
  end
end
