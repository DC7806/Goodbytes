class InviteMailerJob < ApplicationJob
  queue_as :default

  def perform(name, email, token, user_exist)
    # Do something later
    InviteMailer.send_invite(name, email, token, user_exist).deliver
  end
end
