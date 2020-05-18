class Channel < ApplicationRecord
  has_many :link_groups,        dependent: :destroy
  has_many :invites, as: :item, dependent: :destroy
  has_many :channels_org_users, dependent: :destroy
  has_many :organizations_users,  through: :channels_org_users
  has_many :users,                through: :organizations_users
  has_many :saved_links,          through: :link_groups
  has_many :articles

  belongs_to :organization
  
  validates :name, presence: true

  def role(user_id)
    result = relationship(user_id)
    return result && result.role || "None"
  end

  def update_role(user_id, role)
    org_role = organization.relationship(user_id)
    
    if org_role
      channel_role = relationship(user_id)
      if channel_role
        channel_role.role = role
        channel_role.save
      else
        channels_org_users.create(
          organizations_user_id: org_role.id,
          role: role
        )
      end
      return true
    else
      return false
    end
  end

  def relationship(user_id)
    ChannelsOrgUser.find_by_sql("
      select ch.* 
      from channels_org_users ch
      inner join organizations_users org
      on ch.organizations_user_id = org.id and org.user_id=#{user_id}
      where ch.channel_id = #{id}
    ").first
  end

  def users_with_role
    result = User.find_by_sql("
      select users.*,ch_rel.role
      from users
      inner join organizations_users org_rel
      on users.id=org_rel.user_id 
      inner join channels_org_users ch_rel
      on org_rel.id=ch_rel.organizations_user_id 
      where ch_rel.channel_id=#{id}
    ")
    result.each do |user|
      user.role = user.attributes["role"]
    end
    return result
  end


end
