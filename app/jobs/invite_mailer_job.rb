class InviteMailerJob < ApplicationJob
  queue_as :default

  def perform(name, organization_id, email)
    # Do something later
    InviteMailer.send_invite(name, organization_id, email).deliver
  end
end
