class SubscribersController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :find_channel
  before_action :find_subscriber, only: [:destroy]

  def create
    # 傳入參數預期應該會有
    #   id: channel id
    #   email: 訂閱者email

  end

  def destroy
    # 傳入參數預期應該會有
    #   id: channel id
    #   email: 訂閱者email

  end

  private
    def find_channel
      # 因為訂閱者不一定有登入，所以不適用共同的 find channel規則
      # 故重寫一個
      @channel = Channel.find(params[:id])
    end
    
    def find_subscriber
      @subscriber = @channel.subscribers.find_by(email: params[:email])
    end

end
