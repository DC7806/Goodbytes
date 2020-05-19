class Invite < ApplicationRecord
  belongs_to :item, polymorphic: true
  belongs_to :sender, class_name: "User"

  def type_in_chinese
    case item_type
    when "Organization"
      "組織"
    when "Channel"
      "頻道"
    end
  end
  
  def accept_attr
    case item_type
    when "Organization"
      { 
        organization_id: item_id, 
        invite_token: token
      }
    when "Channel"
      { 
        organization_id: item.organization_id, 
        channel_id: item_id, 
        invite_token: token
      }
    end
  end

  def deny_attr
    { invite_token: token }
  end
  
end
