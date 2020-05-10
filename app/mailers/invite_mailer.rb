class InviteMailer < ApplicationMailer
  def send_invite(name, organization_id, email)
    @organization_id = organization_id
    @email = email
    mail to: @email, subject: "來自 #{name} 的邀請"
  end
end
