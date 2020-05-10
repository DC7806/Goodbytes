class InviteMailer < ApplicationMailer
  def send_invite(name, organization_id, email, invite_token)
    @organization_id = organization_id
    @email = email
    @invite_token = invite_token
    mail to: @email, subject: "來自 #{name} 的邀請"
  end
end
