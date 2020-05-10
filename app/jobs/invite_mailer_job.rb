class InviteMailerJob < ApplicationJob
  queue_as :default

  def perform(name, organization_id, email, invite_token)
    # Do something later
    InviteMailer.send_invite(name, organization_id, email, invite_token).deliver
  end
end
