class SavedLink < ApplicationRecord
  belongs_to :link_group

  validates :url, presence: true
  validates :subject, presence: true

  def path_params
    {
      id: id,
      link_group_id: link_group_id
    }
  end
end
