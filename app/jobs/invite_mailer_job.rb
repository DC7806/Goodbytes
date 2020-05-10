class InviteMailerJob < ApplicationJob
  queue_as :default

  def perform(name, organization_id, email, invite_token, registable)
    # Do something later
    InviteMailer.send_invite(name, organization_id, email, invite_token, registable).deliver
  end
end
