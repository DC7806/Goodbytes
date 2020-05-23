class Channel < ApplicationRecord
  has_many :articles,           dependent: :destroy
  has_many :link_groups,        dependent: :destroy
  has_many :invites, as: :item, dependent: :destroy
  has_many :channels_org_users, dependent: :destroy
  has_many :organizations_users,  through: :channels_org_users
  has_many :users,                through: :organizations_users
  has_many :saved_links,          through: :link_groups

  belongs_to :organization
  
  validates :name, presence: true

  attr_accessor :purview

  # 回傳跟user_id相符合的關係鏈物件
  # 在channel身上呼叫就是channel的關係鏈
  # 在organization身上呼叫就是organization的關係鏈
  def relationship(user_id)
    channels_org_users.includes(:organizations_user).find do |rel|
      rel.organizations_user.user_id == user_id
    end
  end

  # 查詢該user_id的權限
  def role(user_id)
    result = relationship(user_id)
    # 如果有查到就回傳權限字串，如果沒有就回傳none
    return result && result.role || "None"
  end

  # 更新該user_id的權限
  # 在channel要更新，因為多一層關係的查詢（查詢使用者是否在organization內）
  # 會比organization層級查權限還複雜
  # 不過不用擔心，方法我都寫好了，只要會用就好
  def update_role(user_id, role)
    # 首先找出該user_id是否在channel歸屬的organization內
    org_role = organization.relationship(user_id)
    if org_role
      # 如果在organization內就再進一步找是否在channel內
      channel_role = relationship(user_id)
      if channel_role
        # 如果在channel內就更新權限
        channel_role.update(role: role)
      else
        # 如果不在channel內就創建一個關係鏈
        channels_org_users.create(
          organizations_user_id: org_role.id,
          role: role
        )
      end
      return true
    else
      # 如果更新成功回傳true，沒有則回傳false，提供外面的controller判斷是否成功
      return false
    end
  end
  
  # 回傳users列表，跟一般users列表不同的是這是身上帶有在此channel內之權限資料的user物件
  # 因為user model本身並沒有role欄位，而這本就不該綁在user model的欄位裡面
  # 因為user在不同的organization以及不同的channel本就會有不同的權限
  # 我在user model偷偷塞了 attr_accessor :role 
  # 所以這邊可以進行 user.role = 這樣的操作
  # 把權限資料暫時地塞到user物件身上
  # 當然下次在別的場合呼叫user物件時，物件身上就不一定會有一樣的role資料了
  # 此方法會使用在後台頁面的成員列表
  def users_with_role
    channels_org_users.includes(:organizations_user).includes(:user).map do |ch_rel|
      user = ch_rel.organizations_user.user
      user.role = ch_rel.role
      user
    end
  end


end
