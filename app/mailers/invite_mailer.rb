class InviteMailer < ApplicationMailer
  def send_invite(name, email, invite_token, registable)
    @email = email
    @invite_token = invite_token
    @user_exist = !registable
    mail to: @email, subject: "來自 #{name} 的邀請"
  end
end
