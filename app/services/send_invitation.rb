class SendInvitation

  # 在user model會傳入user id
  # 初始的model object是沒有的，需要後面再傳入
  def initialize(user_id)
    @user_id = user_id
    @model_object = nil
  end

  # 傳入channel or organization物件
  def from(model_object)
    unless @model_object
      @model_object = model_object
      # return self的意思是把自己這個物件再傳出去
      # 所以我可以在外面做到像是 
      # current_user.send_invitation.from(@channel).to("blabla123@gmail.com")
      # 這樣很口語化的介面
      return self
    else
      # 同一次send_invitation只能定義一次model_object
      raise TypeError, 'SendInvitation: Do not duplicated the model_object defination.'
    end
  end

  def to(email)
    unless @model_object
      # 還沒定義好model object就想送信是不行的唷～揪咪～＊
      raise NameError, 'SendInvitation: model_object undefine yet.'
    end
    
    relationship = @model_object.users
                                .find_by(email: email)
    # 找找看這個model object跟指定的email有沒有關聯
    # 換句話說就是指定的email是否已加入該channel或organization
    # 如果已加入就會跳過以下動作直接到最下方 return false
    unless relationship
      
      last_invitation = @model_object.invites
                                     .find_by(receiver: email)
      # 找找看指定的email是否正在被邀請中
      # 如果有，token就改用跟之前一樣的，且不會創新的invite記錄
      # 如果沒有，就產生新token並且創一筆新的invite資料
      if last_invitation
        invitation_token = last_invitation.token
      else
        # 產生長度為20的隨機數字與英文字串
        invitation_token  = generate_token(20)
        @model_object.invites.create(
          token: invitation_token,
          sender_id: @user_id,
          receiver: email
        )
      end

      # 到了這邊，就是寄出啦
      # mailer方法參數格式： name, email, invite_token, user_exist
      # 第四個user_exist是『使用者是否存在』，用來控制郵件樣板的呈現方式
      # 對於未註冊跟已註冊的email就可以是兩種連結，甚至是兩種格式
      InviteMailerJob.perform_later(
        @model_object.name,
        email, 
        invitation_token, 
        !!User.find_by(email: email)
      )
      # return true or false來提供controller判斷是否寄送成功，再讓他進行後續動作
      return true
    end
    return false
  end

  private
  def generate_token(length)
    # length: 想要的字串長度，must be integer
    # rand: 產生指定範圍的隨機數字
    # to_s: 後面給個數字代表要將數字以幾進位方式轉字串
    # example: 
    #   21.to_s(2) => "10101"
    #   878.to_s(16) => "36e"
    #   2989.to_s(16) => "bad"
    #   29234652.to_s(36) => "hello"
    # 要是反過來，"hello".to_i(36) 就會得到29234652
    # 最高就是只能到36進位，0～9以及a～z
    # 沒有大寫
    length.times.map{rand(0..35).to_s(36)}.join
  end

end