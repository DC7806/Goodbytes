class Invite < ApplicationRecord
  belongs_to :item, polymorphic: true
  belongs_to :sender, class_name: "User"
end
