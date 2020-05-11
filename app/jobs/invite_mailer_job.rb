class InviteMailerJob < ApplicationJob
  queue_as :default

  def perform(name, email, invite_token, registable)
    # Do something later
    InviteMailer.send_invite(name, email, invite_token, registable).deliver
  end
end
