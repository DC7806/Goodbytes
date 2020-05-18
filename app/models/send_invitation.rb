class SendInvitation

  def initialize(user_id)
    @user_id = user_id
    @acceptor = nil
  end

  def by_org(org_id)
    acceptor_defined_by Organization.find(org_id)
  end

  def by_channel(ch_id)
    acceptor_defined_by Channel.find(ch_id)
  end  

  def to(target)
    unless @acceptor
      raise NameError, 'SendInvitation: Acceptor undefine yet.'
    end
    invitation_token  = generate_token(20)
    relationship  = @acceptor.users
                             .find_by(email: target)

    unless relationship 
      last_invitation = @acceptor.invites
                                 .find_by(receiver: target)

      if last_invitation
        invitation_token = last_invitation.token
      else
        @acceptor.invites.create(
          token: invitation_token,
          sender_id: @user_id,
          receiver: target
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

  private
  def acceptor_defined_by(acceptor)
    unless @acceptor
      @acceptor = acceptor
      return self
    else
      raise TypeError, 'SendInvitation: Do not duplicated the acceptor defination.'
    end
  end

  def generate_token(len)
    len.times.map{rand(0..35).to_s(36)}.join
  end

end