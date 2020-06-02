class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
                                    :recoverable, 
                                    :rememberable, 
                                    :validatable

  #associations
  has_many    :organizations_users, dependent: :destroy
  has_many          :organizations, through: :organizations_users

  has_many     :channels_org_users, through: :organizations_users
  has_many               :channels, through: :channels_org_users
  
  # 因為使用者同時會有寄出的邀請與收到的邀請，所以命名要分send跟receive
  has_many           :send_invites, class_name: "Invite", 
                                    foreign_key: "sender_id",
                                    dependent: :destroy

  # 原本的收件箱查詢功能經google後查到可以這樣做，就不用7788的sql語法了
  # 指定primary_key可以指定要用user的哪個欄位做查詢
  # 因為invite的receiver欄位存的是email，所以一樣要以email做查詢
  has_many        :receive_invites, class_name: "Invite",
                                    foreign_key: "receiver",
                                    primary_key: "email"
  
  #validations
  validates                 :email, presence: true, 
                                    uniqueness: true, 
                                    length: { 
                                      minimum: 1, 
                                      maximum: 100 
                                    },
                                    format: { 
                                      with: /\A[a-z]+[a-z0-9]+((_|\.)[a-z0-9]+)*@[a-z]+(\.[a-z]+){1,3}\z/ 
                                    }
  # ＠前只允許小寫英文開頭、可接底線或點號，＠後小寫英文開頭、後面可接點號接域名等等，最多不超過三組

  validates    :encrypted_password, presence: true, 
                                    length: { 
                                      minimum: 6, 
                                      maximum: 128 
                                    }

  attr_accessor :role
  
  # 因為organization跟channel已有相應的role方法，不能再用role當做塞權限資料的方法
  # 所以改用purview，一樣是權限的意思
  # 賣構問啊！！！！！
  def organizations_with_purview
    organizations_users.includes(:organization).map do |relationship|
      organization = relationship.organization
      organization.purview = relationship.role
      organization 
    end
  end

  def channels_with_purview
    channels_org_users.includes(:channel).map do |rel|
      channel = rel.channel
      channel.purview = rel.role
      channel
    end
  end

  # 詳情請見SendInvitation class，這邊會傳入user id
  def send_invitation
    return SendInvitation.new(id)
  end

end
