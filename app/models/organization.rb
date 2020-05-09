#每次豪華福州校園隨意紛紛財政群眾最後裝飾回到這是地說那天坐。
class Organization < ApplicationRecord
  #associations
  has_many :organizations_users, dependent: :destroy
  has_many :users, through: :organizations_users
  
  #validations
  validates :name, presence: true, uniqueness: true, length: { minimum: 1, maximum: 100 }

  attr_accessor :purview #權限
  
  alias_method :native_users, :users
  def users
    result = User.find_by_sql("
        select users.*,rel.role
        from users
        inner join organizations_users rel
        on users.id=rel.user_id 
        inner join organizations org
        on org.id=rel.organization_id 
        where org.id=#{id}
      ")
    result.each do |user|
      user.role = user.attributes["role"]
    end
    return result
  end
end

# select users.id,users.email,users.name,rel.role
# from users
# inner join organizations_users rel
# on users.id=rel.user_id 
# inner join organizations org
# on org.id=rel.organization_id 
# where org.id=5