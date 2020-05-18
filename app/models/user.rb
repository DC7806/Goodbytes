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

  has_many     :channels_org_users, through: :organizations_users, dependent: :destroy
  has_many               :channels, through: :channels_org_users
  
  has_many           :send_invites, class_name: "Invite", 
                                    foreign_key: "sender_id"
  
  #validations
  validates                 :email, presence: true, 
                                    uniqueness: true, 
                                    length: { 
                                      minimum: 1, 
                                      maximum: 100 
                                    }
  validates    :encrypted_password, presence: true, 
                                    length: { 
                                      minimum: 6, 
                                      maximum: 128 
                                    }

  attr_accessor :role
  
  def organizations_with_purview
    result = Organization.find_by_sql("
      select org.*, rel.role purview
      from organizations org
      inner join organizations_users rel
      on org.id=rel.organization_id 
      inner join users
      on users.id=rel.user_id 
      where users.id=#{id}
    ")
    result.each do |organization|
      organization.purview = organization.attributes["purview"]
    end
    return result
  end
  def receive_invites
    Invite.find_by_sql("
      select users.email, org.name, org.id, invs.token
      from invites invs
      inner join organizations org
      on org.id=invs.item_id and invs.item_type='Organization'
      inner join users
      on users.id=invs.sender_id
      where invs.receiver='#{email}'
    ").map{|x|
    dic = x.attributes
    Result.new(
      email: dic["email"],
      name: dic["name"],
      accept_attr: {organization_id: dic["id"],invite_token: dic["token"]},
      deny_attr: {invite_token: dic["token"]}
      )
    } +
    Invite.find_by_sql("
      select users.email, ch.name, ch.id, ch.organization_id, invs.token
      from invites invs
      inner join channels ch
      on ch.id=invs.item_id and invs.item_type='Channel'
      inner join users
      on users.id=invs.sender_id
      where invs.receiver='#{email}'
    ").map{|x|
    dic = x.attributes
    Result.new(
      email: dic["email"],
      name: dic["name"],
      accept_attr: {organization_id: dic["organization_id"],invite_token: dic["token"], channel_id: dic["id"]},
      deny_attr: {invite_token: dic["token"]}
      )
    }
  end

  def send_invitation
    return SendInvitation.new(id)
  end

  def organizations_table
    organizations_collection = organizations.includes(:organizations_users).includes(:users)
    result = organizations_collection.map do |org|
      Result.new(
        id:    org.id,
        name:  org.name,
        users: org.users.map{|user|
          Result.new(
            id:    user.id,
            email: user.email,
            name:  user.name,
            role:   org.organizations_users
                       .find{|rel| rel.user_id == user.id}
                       .role
          )
        }
      )
    end

    return result
  end

end
