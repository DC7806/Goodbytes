class Invite < ApplicationRecord
  belongs_to :item, polymorphic: true
  belongs_to :sender, class_name: "User"

  def type_in_chinese
    case item_type
    when "Organization"
      "組織"
    when "Channel"
      "頻靓"
    end
  end
  
end
