class InviteMailer < ApplicationMailer
  default from: 'invitation@mailby.goodbyt.es'
  def send_invite(name, email, invite_token, user_exist)
    @email = email
    @invite_token = invite_token
    @user_exist = user_exist
    mail to: @email, subject: "來自 #{name} 的邀請"
  end
end
