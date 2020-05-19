class InviteMailerJob < ApplicationJob
  queue_as :default

  def perform(name, email, invite_token, user_exist)
    # Do something later
    InviteMailer.send_invite(name, email, invite_token, user_exist).deliver
  end
end
