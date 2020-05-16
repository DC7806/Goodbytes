class SendBranching

  def initialize(curr_user_id)
    @curr_user_id = curr_user_id
  end

  def by_org(org_id)
    return Sender.new(
      Organization.find(org_id), 
      @curr_user_id
    )
  end

  def by_channel(ch_id)
    return Sender.new(
      Channel.find(ch_id), 
      @curr_user_id
    )
  end

  class Sender
    def initialize(acceptor, curr_user_id)
      @acceptor = acceptor
      @curr_user_id = curr_user_id
    end
    
    def generate_token(len)
      len.times.map{rand(0..35).to_s(36)}.join
    end

    def to(target)
      invitation_token  = generate_token(20)
      relationship  = @acceptor.users
                               .find_by(email: target)

      unless relationship 
        last_invitation = @acceptor.invites
                                   .find_by(reciever: target)

        if last_invitation
          invitation_token = last_invitation.token
        else
          @acceptor.invites.create(
            token: invitation_token,
            sender_id: @curr_user_id,
            reciever: target
          )
        end

        InviteMailerJob.perform_later(
          @acceptor.name,
          target, 
          invitation_token, 
          !User.find_by(email: target)
        )
        return true
      end
      return false
    end
  end

end