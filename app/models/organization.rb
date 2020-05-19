#每次豪華福州校園隨意紛紛財政群眾最後裝飾回到這是地說那天坐。
class Organization < ApplicationRecord
  #associations
  has_many :channels,            dependent: :destroy
  has_many :organizations_users, dependent: :destroy
  has_many :invites, as: :item,  dependent: :destroy
  has_many :users,                 through: :organizations_users
  
  #validations
  validates :name, presence: true, 
                   uniqueness: true, 
                   length: { minimum: 1, maximum: 100 }

  attr_accessor :purview
  
  # 關於此系列關係鏈操作，詳細註解寫在channel
  # 因為那邊的關係鏈比較複雜，所以以那邊為例
  def relationship(user_id)
    organizations_users.find_by(
      user_id: user_id
    )
  end

  def role(user_id)
    result = relationship(user_id)
    return result && result.role || "None"
  end

  def update_role(user_id, role)
    org_rel = relationship(user_id)
    if org_rel
      org_rel.role = role
      org_rel.save
    else
      organizations_users.create(
        user_id: user_id,
        role: role
      )
    end
    return true
  end

  def users_with_role
    organizations_users.includes(:user).map do |relationship|
      user = relationship.user
      user.role = relationship.role
      user
    end
  end

end

