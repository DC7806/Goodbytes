class Channel < ApplicationRecord
  has_many :invites, as: :item

  has_many :channels_org_users
  has_many :organizations_users, through: :channels_org_users
  has_many :users, through: :organizations_users

  belongs_to :organization

  def role(user_id)
    result = ChannelsOrgUser.find_by_sql("
      select * 
      from channels_org_users ch
      inner join organizations_users org
      on ch.organizations_user_id = org.id
      inner join users
      on users.id = #{user_id} and users.id = org.user_id
      where ch.id = #{id}
      ").first
    return result && result.role || "None"
  end

end
